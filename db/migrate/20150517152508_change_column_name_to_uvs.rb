class ChangeColumnNameToUvs < ActiveRecord::Migration
  def change
     rename_column :uvs, :remak, :remark
  end
end
