class RemoveTimeFromRedpack < ActiveRecord::Migration
  def change
    remove_column :redpacks, :time, :datetime
  end
end
