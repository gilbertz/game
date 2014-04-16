class AddColumnUserIdToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :user_id, :integer, :null => false, :default => 1
    add_index :materials, :user_id
  end
end
