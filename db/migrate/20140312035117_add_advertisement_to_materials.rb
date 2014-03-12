class AddAdvertisementToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :advertisement_1, :text
  end
end
