class CreateWeixins < ActiveRecord::Migration
  def change
    create_table :weixins do |t|
      t.string :wxid
      t.boolean :active
      t.integer :tid

      t.timestamps
    end
  end
end
