class AddIndexToAuthentications < ActiveRecord::Migration
  def change
    add_index :authentications, :uid
    add_index :authentications, :user_id
    add_index :authentications, :appid
    add_index :authentications, :groupid

  end
end
