class ChangeComment < ActiveRecord::Migration
  def change
    change_table :comments do |t|
      t.integer :upvotes, default: 0, null: false
      t.integer :downvotes, default: 0,null: false
    end
  end
end
