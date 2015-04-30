class AddRedpackTimeIdToTimeAmount < ActiveRecord::Migration
  def change
    add_column :time_amounts, :redpack_time_id, :integer
  end
end
