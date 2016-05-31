class CreateQuestionsTopics < ActiveRecord::Migration
  def change
    create_table :questions_topics do |t|
      t.references :question, index: true, null: false
      t.references :topic, index: true, null: false 
      t.timestamps null: false
    end
  end
end
