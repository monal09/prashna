class ChangeOrder < ActiveRecord::Migration
  def change
  	rename_column :orders, :credit_amount, :credit_points
  end
end
