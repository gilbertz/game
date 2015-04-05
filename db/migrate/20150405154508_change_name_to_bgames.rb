class ChangeNameToBgames < ActiveRecord::Migration
  def change
    rename_column :bgames, :ibeacon_id, :beaconid
  end
end
