class ChangeColumnNameToChecks < ActiveRecord::Migration
  def change
    rename_column :checks, :beacondid, :beaconid
  end
end
