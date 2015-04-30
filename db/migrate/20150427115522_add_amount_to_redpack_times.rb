class AddAmountToRedpackTimes < ActiveRecord::Migration
  def change
    add_column :redpack_times, :amount, :integer
  end
end
