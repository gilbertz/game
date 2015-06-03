class AddDeleteAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :deleted_at, :datetime
  end
end
