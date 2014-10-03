class CreateWxConfigs < ActiveRecord::Migration
  def change
    create_table :wx_configs do |t|
      t.boolean :wx_ad
      t.string :wx_link
      t.string :wx_id
      t.string :secret

      t.timestamps
    end
  end
end
