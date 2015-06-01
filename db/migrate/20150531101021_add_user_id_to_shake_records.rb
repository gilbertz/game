class AddUserIdToShakeRecords < ActiveRecord::Migration
  def change
    add_column :shake_records, :user_id, :integer
    add_index :shake_records, :user_id
  end
end
