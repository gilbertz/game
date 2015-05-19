class AddPayTypeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :pay_type, :integer
    add_column :orders, :trade_type, :string
    add_column :orders, :openid, :string
    add_column :orders, :party_id,:Integer
  end
end
