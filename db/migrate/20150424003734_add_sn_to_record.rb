class AddSnToRecord < ActiveRecord::Migration
  def change
    add_column :records, :sn, :string
  end
end
