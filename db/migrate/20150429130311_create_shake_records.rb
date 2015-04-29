class CreateShakeRecords < ActiveRecord::Migration
  def change
    create_table :shake_records do |t|
      t.string :request_url
      t.integer :activityid
      t.string :ticket

      t.timestamps
    end
  end
end
