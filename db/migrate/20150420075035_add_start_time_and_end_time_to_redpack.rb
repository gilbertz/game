class AddStartTimeAndEndTimeToRedpack < ActiveRecord::Migration
  def change
    add_column :redpacks, :start_time, :datetime
    add_column :redpacks, :end_time, :datetime
  end
end
