class AddFakeAmountToTimeAmount < ActiveRecord::Migration
  def change
    add_column :time_amounts, :fake_amount, :integer
  end
end
