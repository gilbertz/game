class AddIndexToChecksAndTimeamount < ActiveRecord::Migration
  def change
    add_index :checks, :user_id
    add_index :checks, :beaconid
    add_index :checks, :game_id
    add_index :checks, :state
    add_index :checks, :created_at
    add_index :checks, [:user_id, :beaconid, :game_id]
    add_index :checks, [:user_id, :beaconid, :game_id, :created_at]
   
    add_index :time_amounts, :time
    add_index :time_amounts, :redpack_time_id
    add_index :time_amounts, [:time, :redpack_time_id]  
  end
end
