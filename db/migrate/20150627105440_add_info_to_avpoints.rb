class AddInfoToAvpoints < ActiveRecord::Migration
  def change
    add_column :advpoints, :trans_desc, :text
    add_column :advpoints, :facility_desc, :text
    add_column :advpoints, :people_flow, :string
  end
end
