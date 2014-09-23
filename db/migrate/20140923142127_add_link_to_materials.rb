class AddLinkToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :link, :string
  end
end
