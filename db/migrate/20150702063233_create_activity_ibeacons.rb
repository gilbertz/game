class CreateActivityIbeacons < ActiveRecord::Migration
  def change
    create_table :activity_ibeacons do |t|
      t.integer :ibeacon_id
      t.integer :activity_id
      t.integer :status
      t.string :remark
      t.integer :party_id

      t.timestamps
    end
  end
end
