class AddAverageAndRemainToRedpackTimes < ActiveRecord::Migration
  def change
    add_column :redpack_times, :average, :integer
    add_column :redpack_times, :remain, :integer
  end
end
