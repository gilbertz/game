class AddMaterialIdToRedpacks < ActiveRecord::Migration
  def change
    add_column :redpacks, :material_id, :integer
  end
end
