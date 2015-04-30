class AddNumToRedpackValues < ActiveRecord::Migration
  def change
    add_column :redpack_values, :num, :integer
  end
end
