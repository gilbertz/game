class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.integer :wait, :null => false, :default => 1
      t.string :image_url
      t.timestamps
    end
  end
end
