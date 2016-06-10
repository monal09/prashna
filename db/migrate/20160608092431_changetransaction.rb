class Changetransaction < ActiveRecord::Migration
  def change
  	add_reference :transactions, :order, index: true 
  end
end
