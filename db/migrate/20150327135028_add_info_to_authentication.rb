class AddInfoToAuthentication < ActiveRecord::Migration
  def change
    add_column :authentications, :unionid, :string
    add_index :authentications, :unionid
  end
end
