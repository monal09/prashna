class ChangeUsers < ActiveRecord::Migration

  def change
    add_column :users, :total_credits, :float, default: 0, null: false
  end

end
