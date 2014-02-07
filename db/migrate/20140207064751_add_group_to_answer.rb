class AddGroupToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :group, :integer, after: :title
  end
end
