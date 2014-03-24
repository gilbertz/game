class AddColumnIsQqToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :is_qq, :integer, :null => false, :default => 0
  end
end
