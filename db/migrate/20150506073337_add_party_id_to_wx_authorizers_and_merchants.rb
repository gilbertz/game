class AddPartyIdToWxAuthorizersAndMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :party_id, :string

    add_column :wx_authorizers, :party_id, :string
  end
end
