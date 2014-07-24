class ModerationsController < ApplicationController

	before_filter { authorize! :verify, Topic }

	def show		
		@topic_report = ModerationReport.new params[:moderation_report] do |scope|
			scope = scope.where("\"topics\".\"id\" NOT IN (SELECT topic_id FROM #{Rejection.table_name} WHERE unchanged=?)",true) if params[:all].blank?
			scope
		end
		@assets = @topic_report.assets.paginate page: params[:page]		
	end

	def update

		params[:ids].to_a.each do |topic_id|
			if params[:commit] == 'publish'
				topic = Topic.find topic_id
				topic.published = true			
				topic.save
			elsif params[:commit] == 'reject'				
				Rejection.create do |rejection|
					rejection.topic_id = topic_id
					rejection.user_id = current_user.id
					rejection.reason = params[:reason]
				end
			end
		end

		if params[:commit] == 'publish'
			flash[:success] = I18n.t("topics.published_success",:default=>"Topic(s) published successfully.")
		elsif params[:commit] == 'reject'
			flash[:success] = I18n.t("topics.rejection_success",:default=>"Topic(s) rejected successfully.")
		end
		redirect_to moderation_path
	end


end