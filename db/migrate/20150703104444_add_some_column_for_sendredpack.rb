class AddSomeColumnForSendredpack < ActiveRecord::Migration
  def change
    add_column :payments, :send_listid, :string
    add_column :payments, :pattern, :integer
    add_column :payments, :beaconid, :integer

    add_index :payments, :pattern
    add_index :payments, :beaconid
    add_index :payments, [:beaconid,:pattern]


    add_column :redpacks, :amt_list, :string
    add_column :redpacks, :amt_total, :integer
    add_column :redpacks, :amt_num, :integer
    add_column :redpacks, :logo_imgurl, :string
    add_column :redpacks, :watermark_imgurl, :string
    add_column :redpacks, :banner_imgurl, :string

    add_index :redpacks, :pattern
  end
end
