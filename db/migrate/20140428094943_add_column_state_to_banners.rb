class AddColumnStateToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :state, :integer, :null => false, :default => 0
  end
end
