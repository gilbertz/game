class AddSomeFieldToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :appid, :string
    add_column :authentications, :city, :string
    add_column :authentications, :province, :string
    add_column :authentications, :sex, :string

  end
end
