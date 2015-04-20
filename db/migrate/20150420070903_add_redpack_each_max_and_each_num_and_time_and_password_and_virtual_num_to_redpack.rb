class AddRedpackEachMaxAndEachNumAndTimeAndPasswordAndVirtualNumToRedpack < ActiveRecord::Migration
  def change
    add_column :redpacks, :each_max, :integer
    add_column :redpacks, :each_num, :integer
    add_column :redpacks, :time, :datetime
    add_column :redpacks, :password, :integer
    add_column :redpacks, :virtual_num, :integer
  end
end
