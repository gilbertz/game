class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :user_id
      t.integer :beaconid
      t.integer :value
      t.integer :from_user_id
      t.string :remark

      t.timestamps
    end
  end
end
