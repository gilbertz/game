class AddIsfollowToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :isfollow, :string
  end
end
