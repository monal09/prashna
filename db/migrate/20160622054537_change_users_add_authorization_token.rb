class ChangeUsersAddAuthorizationToken < ActiveRecord::Migration
  def change
    add_column :users, :authorization_token, :string, index: true
  end
end
