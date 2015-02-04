class PagesController < ApplicationController

	layout 'v2'

	def home
	end

	def topics
		@locations = Location.tagged.joins(:topics).includes(:topics).to_a
		render json: @locations.to_json(include: :topics)
	end
	
end