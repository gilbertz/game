class AddDescAndImgToUser < ActiveRecord::Migration
  def change
    add_column :users, :desc, :string
    add_column :users, :profile_img_url, :string
  end
end
