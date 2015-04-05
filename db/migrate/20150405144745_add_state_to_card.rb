class AddStateToCard < ActiveRecord::Migration
  def change
    add_column :cards, :state, :integer
  end
end
