class TopicReport < BaseReport
	include Datagrid
	scope do
		Topic.order("topics.created_at desc")
	end

	filter(:title, :string) {|value| where("title ilike '#{value}%'")}
	filter(:content, :string) {|value| where("content ilike '#{value}%'")}
	
	column(:actions, :html => true) { |topic| render :partial => "/shared/check_box",:locals => { :s => topic }}
	column(:title, :url => proc {|topic| Rails.application.routes.url_helpers.edit_topic_path(topic) })
	column(:content)
	column(:created_at)
	column(:updated_at)  
	column(:published, :html => true) { |asset|
		html = asset.published? ? "<span style='padding:0 20px 0 30px;'>  #{image_tag('checked.png')} </span>" : "<span style='padding:0 20px 0 30px;'>  #{image_tag('checkbox.png')} </span>" 
		recent_rejected = Rejection.where(:topic_id=>asset.id, :unchanged=>true).last
		unless recent_rejected.nil?
			reason = recent_rejected.reason.blank? ? I18n.t('topics.reason',:default=>"(not specified)") : recent_rejected.reason
			html += image_tag("icon-disconnect.png",:alt=>reason, :title=>reason) 
		end
		html
	}
end