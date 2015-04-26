class CreateWxAuthorizers < ActiveRecord::Migration
  def change
    create_table :wx_authorizers do |t|
      t.string :authorizer_appid
      t.string :component_appid
      t.string :qrcode_url
      t.string :authorizer_info
      t.string :authorization_info
      t.string :authorizer_refresh_token
      t.bool :unthorized

      t.timestamps
    end
  end
end
