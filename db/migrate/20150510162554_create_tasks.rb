class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :service_name
      t.string :time_format
      t.string :appid
      t.string :party_id
      t.text :param_format
      t.string :task_type

      t.timestamps
    end
  end
end
