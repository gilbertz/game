class AddWxTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :wx_token, :string
  end
end
