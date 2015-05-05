class AddMerchantIdToIbeacon < ActiveRecord::Migration
  def change
    add_column :ibeacons, :merchant_id, :integer
  end
end
