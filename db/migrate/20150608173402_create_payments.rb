class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :mch_appid
      t.string :mchid
      t.string :device_info
      t.string :partner_trade_no
      t.string :payment_no
      t.string :payment_time
      t.string :return_code
      t.string :return_msg
      t.string :result_code
      t.string :err_code
      t.string :err_code_des
      t.string :openid


      t.timestamps
    end
  end
end
