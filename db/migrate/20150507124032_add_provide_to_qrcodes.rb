class AddProvideToQrcodes < ActiveRecord::Migration
  def change
    add_column :qrcodes, :provide, :string

  end
end
