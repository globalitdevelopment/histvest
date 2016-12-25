class SearchController < ApplicationController

	def show
		search = Topic.search build_topic_query
		results = search.results.map do |r| 
			{ value: r.title, label: r.title, score: r._score, avatar_path: r.avatar_path, url: hit_search_path(url: r.url, title: r.title, hash: search_hash(r.title)) }
		end		

		search = Person.search build_person_query
		results += search.results.map do |r| 
			text = "#{r.name}, #{r.location.address}"
			{ 
				value: text, 
				label: text, 
				score: r._score, 
				avatar_path: ActionController::Base.helpers.image_path('rt-person-icon.png'), 
				url: hit_search_path(url: person_path(r.pfid), title: text, hash: search_hash(text)) 
			}
		end

		# CensusSearchWorker.perform_async params[:term]
		
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
	
private

	def build_topic_query
		ret = {
			_source: [:title, :avatar_path, :url],
			query: {
				multi_match: {
					query: params[:term],
					fields: ['title', 'locations.address', 'references.title', 'references.creator'],
					type: :phrase_prefix
				}
			},
			filter: {}
		}
		ret[:filter] = { term: { visible?: true } } unless signed_in?
		ret
	end

	def build_person_query
		ret = {
			query: {
				multi_match: {
					query: params[:term],
					fields: ['name', 'location.address'],
					type: :phrase_prefix
				}
			}
		}
		ret
	end

end
