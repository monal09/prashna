class ChangeCredits < ActiveRecord::Migration
  def change
  	rename_column :credits, :amount, :points
  end
end
