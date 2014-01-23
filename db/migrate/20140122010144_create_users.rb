class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :name
      t.string   :encrypt_pwd
      t.string   :salt 
      t.string   :rememberme_token

      t.timestamps
    end
  end
end
