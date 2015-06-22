class WelcomeController < ApplicationController
	layout 'public'
	respond_to :js, :only => [:take_another_topic]

	caches_action :index, expires_in: 10.minutes, cache_path: ->{ {touch: touch?} }

	def index
		@frequent_searches = SearchTopic.where('created_at > ?',Time.now - 7.days).limit(10).to_a
		@topics = Topic.listed
		@rand_topic = @topics.sample
		@front_page_article = Article.where(article_type: "front_page").first

		respond_to do |format|
			format.json {
				@locations = Location.includes(:topics).joins(:topics).merge(@topics).to_gmaps4rails do |location, marker|												
					marker.infowindow render_to_string(:partial => "/welcome/infowindow.html", :locals => { :topics => location.topics.map { |t| Topic.working_version(t) } })
					marker.picture(picture: location.topics.size > 1 ? "http://www.googlemapsmarkers.com/v1/#{location.topics.size}/FD7567/" : "http://www.google.com/intl/en_us/mapfiles/ms/micons/red-dot.png")				
					marker.json type: :topic, count: location.topics.size
				end
				render json: @locations
			}
			format.html {
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