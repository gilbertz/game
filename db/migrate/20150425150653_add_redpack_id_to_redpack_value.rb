class AddRedpackIdToRedpackValue < ActiveRecord::Migration
  def change
    add_column :redpack_values, :redpack_id, :integer
  end
end
