class AddMoneyToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :money, :integer
  end
end
