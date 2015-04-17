class AddObjectTypeAndObjectIdToRecord < ActiveRecord::Migration
  def change
    add_column :records, :object_type, :string
    add_column :records, :object_id, :integer
   
    add_index :records, [:object_type, :object_id] 
 end
end
