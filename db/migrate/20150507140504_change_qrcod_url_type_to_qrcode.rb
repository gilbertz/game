class ChangeQrcodUrlTypeToQrcode < ActiveRecord::Migration
  def change
    change_column :qrcodes,:qrcode_url,:text
  end
end
