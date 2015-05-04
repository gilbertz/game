class ChangeColumnTypeToWxAuthorizers < ActiveRecord::Migration
  def change
     change_column :wx_authorizers,:authorizer_info,:text
     change_column :wx_authorizers,:authorization_info,:text
  end
end
