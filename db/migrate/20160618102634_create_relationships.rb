class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id, null: false, index: true
      t.integer :followed_id, null: false, index: true
      t.timestamps null: false
    end
  end
end