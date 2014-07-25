class ModerationReport
	include Datagrid

	scope do
		Topic.joins(:user).where(:published => false).order("updated_at DESC")
	end
	
	filter(:title, :string) {|value| where("title ilike '%#{value}%'")}
end