class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :notifiable, polymorphic: true, null: false, index: true
      t.string :event
      t.timestamps null: false
    end
  end
end
