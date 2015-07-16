class AddTypeToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :btype, :integer,:default => 0
    add_index :banners, [:activity_id, :state,:btype]
  end
end
