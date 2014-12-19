class WelcomeController < ApplicationController
	layout 'public'
	respond_to :js, :only => [:take_another_topic]

	def index
		@frequent_searches = SearchTopic.where('created_at > ?',Time.now - 7.days).limit(10).to_a
		@topics = Topic.listed

		@rand_topic = Topic.listed.sample

		@locations = Location.includes(:topics).joins(:topics).merge(Topic.listed).to_gmaps4rails do |location, marker|												
			marker.infowindow render_to_string(:partial => "/welcome/infowindow", :locals => { :topics => location.topics.map { |t| Topic.working_version(t) } })
			marker.picture(picture: location.topics.size > 1 ? "http://www.googlemapsmarkers.com/v1/#{location.topics.size}/FD7567/" : "http://www.google.com/intl/en_us/mapfiles/ms/micons/red-dot.png")				
		end

		@people = Location.tagged.includes(:people).joins(:people).to_gmaps4rails do |location, marker|
			marker.infowindow render_to_string(:partial => "/people/infowindow", :locals => { :people => location.people, :location => location })
			marker.picture picture: "/assets/rt-person-icon.png"
		end

		@front_page_article = Article.where(article_type: "front_page").first

		# Render the site using the touch layout if the subdomain is touch.		
		if request.subdomains.first == "touch"
			render "touch_index", layout: "touch"
		end
	end

	def take_another_topic    
		@topics = Topic.published   
		@rand_topic = @topics.sample 
		respond_with @rand_topic   
	end
end