class CreatePushNotificationTokens < ActiveRecord::Migration
  def change
    create_table :push_notification_tokens do |t|
      t.string :auth_token, null: false, index: true
      t.string :p256dh, null: false, index: true
      t.text :endpoint, null: false
      t.references :user, index: true
      t.timestamps null: false
    end
  end
end
