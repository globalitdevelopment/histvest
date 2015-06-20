class SearchController < ApplicationController
	def search	
		# Search published topics		
		@results = Topic.published.assoc_search(params[:term])
		
		@results.take(3).each do |r|
			SearchTopic.increment(r.title)
		end

		results = @results.map do |r| 
			{ value: r.value, label: r.label, avatar_path: r.avatar_path, url: topic_path(r) }
		end

		# there is no option for search from both so need to check in both firstname and lastname
		firstname, lastname = Person.parse_name params[:term]
		names = []
		Person.search(fornavn: firstname).each {|r| names << r.name }
		Person.search(etternavn: lastname).each {|r| names << r.name }
		names.uniq!
		names.sort! {|x,y| x.index(firstname).to_i + x.index(lastname).to_i <=> y.index(firstname).to_i + y.index(lastname).to_i }
		names[0..10].each do |name|
			fornavn, etternavn = Person.parse_name name
			results << { value: name, label: name, avatar_path: image_path('rt-person-icon.png'), url: census_path(fornavn: fornavn, etternavn: etternavn) }
		end

		respond_to do |format|
			format.json do
				if results.size > 0
					render json: results
				else
					render json: [{id: nil, value: I18n.t('seach.no_results'), label: I18n.t('seach.no_results'), avatar_path: image_path("rt-ukjent-icon.png")}].to_json
				end
			end

			format.html do
				if @results.any?
					redirect_to @results.first
				elsif names.any?
					fornavn, etternavn = Person.parse_name params[:term]								
					redirect_to census_path(fornavn: fornavn, etternavn: etternavn)
				else					
					redirect_to "/"
				end 
			end
		end
	end
end