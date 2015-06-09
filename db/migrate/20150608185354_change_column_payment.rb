class ChangeColumnPayment < ActiveRecord::Migration
  def change
    change_column :payments,:return_msg,:text
  end
end
