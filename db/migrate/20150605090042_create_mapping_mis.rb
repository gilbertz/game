class CreateMappingMis < ActiveRecord::Migration
  def change
    create_table :mapping_mis do |t|
      t.integer :material_id
      t.integer :ibeacon_id

      t.timestamps
    end
  end
end
