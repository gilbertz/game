class AddTypeToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :btype, :integer,:default => 0
    add_index :banners, [:component_id, :state,:btype]
  end
end
