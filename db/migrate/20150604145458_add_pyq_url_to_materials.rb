class AddPyqUrlToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :pyq_url, :string
  end
end
