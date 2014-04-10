class AddColumnPvToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :redis_pv, :integer, :limit => 8, :null => false, :default => 0
    add_column :materials, :redis_wx_share_pyq, :integer, :limit => 8, :null => false, :default => 0

    add_index :materials, :redis_pv
    add_index :materials, :redis_wx_share_pyq
  end
end
