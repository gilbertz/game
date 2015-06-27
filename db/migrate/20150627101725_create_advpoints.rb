class CreateAdvpoints < ActiveRecord::Migration
  def change
    create_table :advpoints do |t|
      t.string :company
      t.string :province
      t.string :city
      t.string :address
      t.integer :type
      t.string :mark
      t.integer :party_id

      t.timestamps
    end
  end
end
