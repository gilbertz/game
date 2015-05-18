class AddPayTypeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :pay_type, :integer
  end
end
