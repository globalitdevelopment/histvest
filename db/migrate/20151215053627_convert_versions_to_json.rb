class ConvertVersionsToJson < ActiveRecord::Migration
  def up
    PaperTrail::Version.find_each do |version|
      if version.object
        object = YAML.load(version.object)
        version.update_column :object, ActiveSupport::JSON.encode(object)
      else
        version.update_column :object, nil
      end
    end
    change_column :versions, :object, 'json using object::json'
    add_column :versions, :object_changes, :json
  end
end
