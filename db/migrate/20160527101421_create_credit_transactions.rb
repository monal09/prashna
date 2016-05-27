class CreateCreditTransactions < ActiveRecord::Migration
  def change
    create_table :credit_transactions do |t|
      t.float :amount, null: false
      t.references :user, index: true, null: false
      t.integer :event #ask_question, answer_question, sign_up, buy
      t.integer :resource_id
      t.string :resource_type
      t.timestamps null: false
    end
  end
end
