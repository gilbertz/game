class AddQrcodeUrlToQrcodes < ActiveRecord::Migration
  def change
    add_column :qrcodes, :qrcode_url, :string
    add_column :qrcodes, :scaner, :string
    add_column :qrcodes, :scene_type, :string
  end
end
