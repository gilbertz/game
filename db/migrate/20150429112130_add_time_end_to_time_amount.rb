class AddTimeEndToTimeAmount < ActiveRecord::Migration
  def change
    add_column :time_amounts, :time_end, :datetime
  end
end
