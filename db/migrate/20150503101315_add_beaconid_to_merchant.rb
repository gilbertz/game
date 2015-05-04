class AddBeaconidToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :beaconid, :integer
    
    add_index :merchants, :beaconid 
 end
end
