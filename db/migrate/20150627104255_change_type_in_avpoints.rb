class ChangeTypeInAvpoints < ActiveRecord::Migration
  def change
    rename_column :advpoints, :type, :advtype
  end
end
