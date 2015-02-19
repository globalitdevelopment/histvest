class PeopleController < ApplicationController

	before_action :find_frequent_searches

	def index
		@results = Person.search params.permit(:fornavn, :etternavn, :page)
		by_locations = @results.group_by(&:location_id)	
		@location = Location.where(id: by_locations.keys).to_gmaps4rails do |location, marker|
			people = by_locations[location.id]
			marker.infowindow render_to_string(:partial => "/people/infowindow", :locals => { :people => people, :location => location })
			marker.picture picture: people.size > 1 ? "http://www.googlemapsmarkers.com/v1/#{people.size}/009900/" : "http://www.google.com/intl/en_us/mapfiles/ms/micons/green-dot.png"
			marker.json type: :person, count: people.size
		end		
		@pagination = WillPaginate::Collection.create(params[:page]||1, 50, Person.total_records) { |pager| pager.replace @results }
		render layout: touch? ? 'touch' : 'public'
	end

	def combined
		z = params[:z].to_i
		p = z/2 - 4		

		if z < 15
			scope = Person.joins(:location).where("latitude >= :s AND latitude <= :n AND longitude >= :w AND longitude <= :e", params)
			@data = scope.group("round(latitude::numeric, #{p})").group("round(longitude::numeric, #{p})").count.to_a.map do |r|
				{ latitude: r[0][0].to_f, longitude: r[0][1].to_f, count: r[1] }
			end
		else
			@data = Location.includes(:people).where("latitude >= :s AND latitude <= :n AND longitude >= :w AND longitude <= :e", params).map do |l|
				{ latitude: l.latitude, longitude: l.longitude, address: l.address, people: l.people.map { |p| { name: p.name, url: p.permalink }  } }
			end
		end
		render json: @data
	end

	def show
		@person = Person.find_from_census params[:pfid]
		@location = @person.location.to_gmaps4rails do |location, marker|
			marker.infowindow render_to_string(:partial => "/people/infowindow", :locals => { :people => location.people, :location => location })
			marker.picture picture: location.people.size > 1 ? "http://www.googlemapsmarkers.com/v1/#{location.people.size}/009900/" : "http://www.google.com/intl/en_us/mapfiles/ms/micons/green-dot.png"
			marker.json type: :person, count: location.people.count
		end		
		render layout: touch? ? 'touch' : 'public'
	end

private

	def find_frequent_searches
		@frequent_searches = SearchTopic.where('created_at > ?',Time.now - 7.days).limit(10)
	end

end