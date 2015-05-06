class AddOldUserCardCodeToCardRecords < ActiveRecord::Migration
  def change
    change_column :card_records,:is_give_by_friend,:string

    add_column :card_records, :old_user_card_code, :string

  end
end
