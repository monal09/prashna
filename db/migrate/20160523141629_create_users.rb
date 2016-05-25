class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.boolean :admin, default: false
      t.string :verification_token, unique: true, index: true
      t.datetime :verification_token_expiry_at
      t.datetime :verified_at
      t.string :forgot_password_token, unique: true, index: true
      t.datetime :forgot_password_token_expiry_at
      t.string :remember_me_token, unique: true, index: true
      t.timestamps null: false
    end
  end
end
