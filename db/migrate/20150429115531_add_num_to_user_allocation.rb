class AddNumToUserAllocation < ActiveRecord::Migration
  def change
    add_column :user_allocations, :num, :integer
  end
end
