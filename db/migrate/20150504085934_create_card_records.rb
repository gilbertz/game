class CreateCardRecords < ActiveRecord::Migration
  def change
    create_table :card_records do |t|
      t.string :card_id
      t.string :appid
      t.string :event
      t.datetime :event_time
      t.string :from_user_name
      t.integer :is_give_by_friend
      t.string :user_card_code
      t.string :outer_id

      t.timestamps
    end
  end
end
