class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title, null: false, index: true
      t.text :content, null: false
      t.string :pdf_name
      t.integer :status, null: false
      t.references :user, index: true
      t.string :slug, null: false
      t.timestamps null: false
    end
  end
end
