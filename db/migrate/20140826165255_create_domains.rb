class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :name
      t.boolean :active
      t.integer :tid

      t.timestamps
    end
  end
end
