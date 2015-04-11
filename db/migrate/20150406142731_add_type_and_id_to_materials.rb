class AddTypeAndIdToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :object_type, :string
    add_column :materials, :object_id, :integer
  end
end
