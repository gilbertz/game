class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :beaconid
      t.string :shop_id
      t.string :appid
      t.string :cardid
      t.string :title
      t.string :sub_title
      t.text :desc
      t.integer :store
      t.integer :tid
      t.date :start_date
      t.date :end_date
      
      t.timestamps
    end
  end
end
