class SearchController < ApplicationController

	def show
		search = Topic.__elasticsearch__.client.suggest \
		  index: Topic.index_name,
		  body: {
		    topics: {
		      text: params[:term],
		      completion: { field: :suggest, size: 10 }
		    }
		  }

		results = search['topics'][0]['options'].map do |r| 
			{ value: r['text'], label: r['text'], score: r['score'], avatar_path: r['payload']['avatar'], url: hit_search_path(url: r['payload']['url'], title: r['text'], hash: search_hash(r['text'])) }
		end

		search = Person.__elasticsearch__.client.suggest \
		  index: Person.index_name,
		  body: {
		    people: {
		    	text: params[:term],
		      completion: { field: :suggest, size: 10 }
		    }
		  }

		results += search['people'][0]['options'].map do |r| 
			{ value: r['text'], label: r['text'], score: r['score'], avatar_path: ActionController::Base.helpers.image_path('rt-person-icon.png'), url: hit_search_path(url: r['payload']['url'], title: r['text'], hash: search_hash(r['text'])) }
		end

		results.sort_by! {|r| r['score']}

		CensusSearchWorker.perform_async params[:term]
		
		respond_to do |format|
			format.json { 
				if results.size > 0
					render json: results
				else
					render json: [{id: nil, value: I18n.t('seach.no_results'), label: I18n.t('seach.no_results'), avatar_path: ActionController::Base.helpers.image_path("rt-ukjent-icon.png")}].to_json
				end
			}
			format.html {
				if results.size > 0
					redirect_to results[0][:url]
				else
					redirect_to root_path, notice: I18n.t('seach.no_results')
				end
			}
		end
	end

	def hit
		SearchTopic.increment params[:title] if search_hash(params[:title]) == params[:hash]
		redirect_to params[:url]
	end
	
	# this code is very slow and contains long compuataion operation
	# will be refactored soon
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
			results << { value: name, label: name, avatar_path: ActionController::Base.helpers.image_path('rt-person-icon.png'), url: census_path(fornavn: fornavn, etternavn: etternavn) }
		end

		respond_to do |format|
			format.json do
				if results.size > 0
					render json: results
				else
					render json: [{id: nil, value: I18n.t('seach.no_results'), label: I18n.t('seach.no_results'), avatar_path: ActionController::Base.helpers.image_path("rt-ukjent-icon.png")}].to_json
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