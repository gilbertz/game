class AddStateToTimeAmount < ActiveRecord::Migration
  def change
    add_column :time_amounts, :state, :integer
  end
end
