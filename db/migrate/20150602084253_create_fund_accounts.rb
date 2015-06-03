class CreateFundAccounts < ActiveRecord::Migration
  def change
    create_table :fund_accounts do |t|
      t.decimal :balance
      t.integer :party_id

      t.timestamps
    end
  end
end
