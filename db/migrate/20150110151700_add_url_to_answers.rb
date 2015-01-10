class AddUrlToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :url, :string
  end
end
