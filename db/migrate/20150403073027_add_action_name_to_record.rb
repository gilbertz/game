class AddActionNameToRecord < ActiveRecord::Migration
  def change
    add_column :records, :action_name, :string
  end
end
