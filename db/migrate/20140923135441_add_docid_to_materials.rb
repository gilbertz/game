class AddDocidToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :docid, :string
  
    add_index :materials, :docid
  end
end
