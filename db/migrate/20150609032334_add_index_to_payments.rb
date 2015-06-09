class AddIndexToPayments < ActiveRecord::Migration
  def change
    add_index :payments, :mchid
    add_index :payments, :money
    add_index :payments, :openid
    add_index :payments, :created_at
    add_index :payments, :payment_no

    add_index :payments, [:mchid, :openid]
    add_index :payments, [:mchid, :openid,:created_at]
    add_index :payments, [:mchid, :openid,:payment_no]
    add_index :payments, [:mchid, :openid,:created_at,:payment_no]
  end
end
