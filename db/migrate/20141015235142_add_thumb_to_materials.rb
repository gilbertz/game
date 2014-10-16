class AddThumbToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :thumb, :string
  end
end
