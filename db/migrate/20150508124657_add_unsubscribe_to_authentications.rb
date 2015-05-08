class AddUnsubscribeToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications,:unsubscribe,:boolean

  end
end
