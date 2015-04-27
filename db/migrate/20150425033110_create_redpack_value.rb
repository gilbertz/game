class CreateRedpackValue < ActiveRecord::Migration
  def change
    create_table :redpack_values do |t|
      t.integer :money
    end
  end
end
