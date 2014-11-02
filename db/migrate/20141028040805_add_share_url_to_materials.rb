class AddShareUrlToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :share_url, :string
  end
end
