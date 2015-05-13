class AddGroupidToAuthentications < ActiveRecord::Migration
  def change

    add_column :authentications, :groupid, :string

  end
end
