class AddCardIdToRecords < ActiveRecord::Migration
  def change

    add_column :cards,:wx_authorizer_id,:string
    add_column :records,:card_id,:string
  end
end
