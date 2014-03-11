class AddColumnMaterialTypeToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :material_type, :integer, :default => 0, :null => false
  end
end