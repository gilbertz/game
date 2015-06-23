class AddProbabilityToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :probability, :float
  end
end
