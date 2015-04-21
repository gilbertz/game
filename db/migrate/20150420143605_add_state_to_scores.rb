class AddStateToScores < ActiveRecord::Migration
  def change
    add_column :scores, :state, :integer
  end
end
