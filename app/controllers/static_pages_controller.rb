class StaticPagesController < ApplicationController
	before_filter :authenticate_user!, :only => :admin
	def admin
		@topic = Topic.first
		#authorize! :edit, @topic
	end

	def about
		
	end
end
