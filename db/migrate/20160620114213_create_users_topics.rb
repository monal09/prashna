class CreateUsersTopics < ActiveRecord::Migration
  def change
    create_table :topics_users do |t|
      t.references :user, index: true, null: false
      t.references :topic, index: true, null: false 
      t.timestamps null: false
    end
  end
end
