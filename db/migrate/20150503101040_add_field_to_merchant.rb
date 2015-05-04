class AddFieldToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :name, :string
    add_column :merchants, :state, :integer
    add_column :merchants, :level, :integer
    add_column :merchants, :money, :integer
    add_column :merchants, :user_id, :integer

    add_index :merchants, :user_id
    add_index :merchants, :level
  end
end
