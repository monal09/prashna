class AddCoulumns < ActiveRecord::Migration
  def change
  	add_column :questions, :abuse_reports_count, :integer, default: 0
  	add_column :comments, :abuse_reports_count, :integer, default: 0
  	add_column :answers, :abuse_reports_count, :integer, default: 0 
  end
end
