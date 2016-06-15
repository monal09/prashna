class ChangeQuestin < ActiveRecord::Migration
  def change
  	add_column :questions, :published_at, :datetime
  end
end
