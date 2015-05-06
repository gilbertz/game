class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :party_identifier
      t.string :openid
      t.string :name
      t.string :sex
      t.string :province
      t.string :city
      t.string :country
      t.string :headimgurl
      t.text :privilege
      t.string :unionid
      t.string :provide
      t.string :refresh_access_token
      t.string :access_token

      t.timestamps
    end
  end
end
