class ChangeUsers < ActiveRecord::Migration

  def change
    add_column :users, :credit_balance, :float, default: 0, null: false
  end

end
