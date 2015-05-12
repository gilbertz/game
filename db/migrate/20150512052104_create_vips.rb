class CreateVips < ActiveRecord::Migration
  def change
    create_table :vips do |t|
      t.string :name
      t.string :phone
      t.string :address
      t.integer :party_id

      t.timestamps
    end
  end
end
