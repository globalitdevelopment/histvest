class CreatePeopleTable < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.belongs_to :location
    	t.string :pfid
    	t.string :name
    	t.string :date_of_birth
    	t.string :place_of_birth
    	t.string :description    	
    end
    add_index :people, :pfid, unique: true
    add_index :people, :location_id
  end
end
