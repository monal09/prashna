class ChangeCreditTransactions < ActiveRecord::Migration
  def change
  	rename_column :credit_transactions, :amount, :points
  end
end
