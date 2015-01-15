class AddDeadLinkFieldsToReferences < ActiveRecord::Migration
  def change
  	add_column :references, :is_dead_link, :boolean, default: false
  	add_column :references, :checked_at, :datetime
  end
end
