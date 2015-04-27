class AddRedpackIdToRedpackTimes < ActiveRecord::Migration
  def change
    add_column :redpack_times, :redpack_id, :integer
  end
end
