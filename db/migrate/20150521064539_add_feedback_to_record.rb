class AddFeedbackToRecord < ActiveRecord::Migration
  def change
    add_column :records, :feedback, :integer
  end
end
