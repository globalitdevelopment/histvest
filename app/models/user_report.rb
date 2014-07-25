class UserReport < BaseReport
	include Datagrid
	scope do
		User.order("users.created_at desc")
	end

	filter(:name, :string) {|value| where("name ilike '%#{value}%'")}
	filter(:email, :string) {|value| where("email ilike '%#{value}%'")}

	column(:actions, :html => true) { |user| render :partial => "/shared/check_box",:locals => { :s => user }}
	column(:name)
	column(:email)
	column(:role) { |user| user.role_text }
	column(:status, :html => true) { |user| image_tag(user.status ? "icon-connect.png" : 'icon-disconnect.png') }
	column(:created_at)
end