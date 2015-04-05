class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :score
      t.integer :beaconid
      t.timestamps
    end
    add_index :records, :user_id
    add_index :records, :game_id
    add_index :records, :score
    add_index :records, :beaconid
    add_index :records, [:user_id, :game_id]
    add_index :records, [:game_id, :score]
    add_index :records, [:beaconid, :score]
  end
end
