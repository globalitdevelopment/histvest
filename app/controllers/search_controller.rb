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
		Person.search(1, params[:term]).sample(5).each do |r|
			results << { value: r.name, label: r.name, avatar_path: '/assets/rt-person-icon.png', url: person_path(r.pfid) }
		end

		Person.search(1, nil, params[:term]).sample(5).each do |r|
			results << { value: r.name, label: r.name, avatar_path: '/assets/rt-person-icon.png', url: person_path(r.pfid) }
		end

		respond_to do |format|
			format.json do
				if results.size > 0
					render json: results
				else
					render json: [{id: nil, value: I18n.t('seach.no_results'), label: I18n.t('seach.no_results'), avatar_path: "/assets/rt-ukjent-icon.png"}].to_json
				end
			end

			format.html do
				if @results.any?
					redirect_to @results.first
				else
					redirect_to "/"
				end 
			end
		end
	end
end