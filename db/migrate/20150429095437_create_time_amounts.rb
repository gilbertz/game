class CreateTimeAmounts < ActiveRecord::Migration
  def change
    create_table :time_amounts do |t|
      t.datetime :time
      t.integer :amount

      t.timestamps
    end
  end
end
