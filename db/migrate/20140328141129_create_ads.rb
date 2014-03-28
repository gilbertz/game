class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :title
      t.text :desc
      t.string :img
      t.string :click
      t.boolean :on
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
