class AddColumnIsRecommendToQqToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :is_recommend_to_qq, :integer, :null => false, :default => 0
    add_index :materials, :is_qq
    add_index :materials, :is_recommend_to_qq
  end
end
