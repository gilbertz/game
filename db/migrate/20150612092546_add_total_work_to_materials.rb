class AddTotalWorkToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :total_work, :integer
  end
end
