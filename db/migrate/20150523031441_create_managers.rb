class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.string :name
      t.string :phone
      t.integer :role
      t.string :party_id

      t.timestamps
    end
  end
end
