class CreateCardOptions < ActiveRecord::Migration
  def change
    create_table :card_options do |t|
      t.integer :value
      t.integer :store
      t.string :title
      t.string :img
      t.string :wx_cardid
      t.string :desc
      t.integer :probability

      t.timestamps
    end
  end
end
