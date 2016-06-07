class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, index: true
      t.boolean :upvote, null: false
      t.references :user, index: true
      t.timestamps null: false
    end
  end
end
