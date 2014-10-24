class CreateWcards < ActiveRecord::Migration
  def change
    create_table :wcards do |t|
      t.text :content
      t.text :greet_word
      t.string :user_id
      t.integer :bid
      t.string :music
      t.string :cover
      t.integer :cid

      t.timestamps
    end
  end
end
