class CreateIbeacons < ActiveRecord::Migration
  def change
    create_table :ibeacons do |t|
      t.string :name
      t.integer :user_id
      t.integer :state
      t.string :remark
      t.string :url

      t.timestamps
    end
    add_index :ibeacons, [:user_id]
    add_index :ibeacons, [:url]
  end
end
