class AddRrrToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :rrr, :integer

    add_index :materials, :rrr
  end
end
