class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer :amount, null: false, unique: true
      t.decimal :price, null: false
      t.timestamps null: false
    end
  end
end
