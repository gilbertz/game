class AddGroupIdToCardOptions < ActiveRecord::Migration
  def change
    add_column :card_options, :group_id, :integer
  end
end
