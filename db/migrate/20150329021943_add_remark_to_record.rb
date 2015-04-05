class AddRemarkToRecord < ActiveRecord::Migration
  def change
    add_column :records, :remark, :string
  end
end
