class AddFromUserIdToRecords < ActiveRecord::Migration
  def change
    add_column :records, :from_user_id, :integer
 
    add_index :records, :from_user_id
    add_index :records, [:from_user_id, :user_id]
    add_index :records, [:from_user_id, :score] 
 end
end
