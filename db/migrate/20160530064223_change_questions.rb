class ChangeQuestions < ActiveRecord::Migration
  def change
  	remove_column :questions, :status, :integer
  	add_column :questions, :published, :boolean, default: false
  	# add_column :questions, :slug, :string
  end
end
