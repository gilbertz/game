class AddMaterialIdToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :material_id, :integer
    add_index :banners, [:material_id, :state]
  end
end
