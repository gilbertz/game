class AddAllocationToRecord < ActiveRecord::Migration
  def change
    add_column :records, :allocation, :integer
  end
end
