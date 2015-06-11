class ChangeTypePayment < ActiveRecord::Migration
  def change
    change_column :payments,:err_code_des,:text

  end
end
