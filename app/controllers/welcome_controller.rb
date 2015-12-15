class WelcomeController < ApplicationController
	layout 'public'
	respond_to :js, :only => [:take_another_topic]

	def index
		respond_to do |format|
			format.json {
				if stale? etag: Topic.maximum(:updated_at), last_modified: Topic.maximum(:updated_at), public: true
					@topics = Topic.published
					
					@locations = Location.joins(:topics).includes(topics: :avatar).merge(Topic.published).to_gmaps4rails do |location, marker|
						last_modified = location.topics.map(&:updated_at).max
			      marker.infowindow Rails.cache.fetch("infowindow_#{location.id}_#{last_modified}", expires_in: 1.hour) {
			        render_to_string(:partial => "/welcome/infowindow", formats: [:html], :locals => { :topics => location.topics.map(&:published_version).compact })
			      }
						marker.picture(picture: location.topics.size > 1 ? "http://www.googlemapsmarkers.com/v1/#{location.topics.size}/FD7567/" : "http://www.google.com/intl/en_us/mapfiles/ms/micons/red-dot.png")				
						marker.json type: :topic, count: location.topics.size
					end
					render json: @locations 
				end
			}
			format.html {
				@frequent_searches = SearchTopic.where('created_at > ?',Time.now - 7.days).limit(10).to_a
				@front_page_article = Article.where(article_type: "front_page").first
				@rand_topic = Topic.published.sample
				render "touch_index", layout: "touch" if touch?
			}
		end
	end

	def take_another_topic    
		@topics = Topic.published   
		@rand_topic = @topics.sample 
		respond_with @rand_topic   
	end
end