class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :appid
      t.string :mch_id
      t.string :device_info
      t.string :product_id
      t.string :out_trade_no
      t.string :fee_type
      t.string :total_fee
      t.string :time_start
      t.string :time_expire
      t.string :attach

      t.timestamps
    end
  end
end
