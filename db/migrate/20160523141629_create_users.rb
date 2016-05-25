class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.boolean :admin, default: false
      t.string :verification_token
      t.datetime :verification_token_expiry_at
      t.datetime :verified_at
      t.string :forgot_password_token
      t.datetime :forgot_password_token_expiry_at
      t.string :remember_me_token
      t.timestamps null: false
      #FIXME_AB: index / unique index, default values, null values
    end
  end
end
