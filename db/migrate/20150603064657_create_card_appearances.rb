class CreateCardAppearances < ActiveRecord::Migration
  def change
    create_table :card_appearances do |t|
      t.string :logo
      t.string :head_title
      t.string :background_url
      t.string :title
      t.string :desc
      t.datetime :start_time
      t.datetime :end_time
      t.text :instructions
      t.integer :card_id

      t.timestamps
    end
  end
end
