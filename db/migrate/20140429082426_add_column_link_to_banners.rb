class AddColumnLinkToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :link, :string
  end
end
