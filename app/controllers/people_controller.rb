class PeopleController < ApplicationController

	def show
		@person = Person.find_from_census params[:pfid]
		@location = @person.location.to_gmaps4rails do |location, marker|
			marker.infowindow render_to_string(:partial => "/people/infowindow", :locals => { :people => location.people, :location => location })
			marker.picture picture: location.people.size > 1 ? "http://www.googlemapsmarkers.com/v1/#{location.people.size}/009900/" : "http://www.google.com/intl/en_us/mapfiles/ms/micons/green-dot.png"
			marker.json type: :person, count: location.people.count
		end
		@frequent_searches = SearchTopic.where('created_at > ?',Time.now - 7.days).limit(10)
		render layout: touch? ? 'touch' : 'public'
	end

end