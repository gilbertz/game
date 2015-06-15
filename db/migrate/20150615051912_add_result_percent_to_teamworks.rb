class AddResultPercentToTeamworks < ActiveRecord::Migration
  def change
    add_column :teamworks, :result_percent, :string
  end
end
