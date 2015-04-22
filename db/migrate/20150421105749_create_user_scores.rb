class CreateUserScores < ActiveRecord::Migration
  def change
    create_table :user_scores do |t|
      t.integer :user_id
      t.integer :beaconid
      t.integer :total_score
      t.integer :state

      t.timestamps
    end
  end
end
