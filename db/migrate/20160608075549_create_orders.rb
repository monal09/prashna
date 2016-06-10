class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.float :price
      t.integer :credit_amount
      t.integer :status, default: 0
      t.timestamps null: false
    end
  end
end
