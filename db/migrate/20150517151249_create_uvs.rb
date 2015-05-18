class CreateUvs < ActiveRecord::Migration
  def change
    create_table :uvs do |t|
      t.integer :user_id
      t.integer :beaconid
      t.integer :game_id
      t.string :remak

      t.timestamps
    end
  end
end
