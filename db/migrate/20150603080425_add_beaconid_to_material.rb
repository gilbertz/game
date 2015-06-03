class AddBeaconidToMaterial < ActiveRecord::Migration
  def change
    add_column :materials, :beacon_id, :integer
  end
end
