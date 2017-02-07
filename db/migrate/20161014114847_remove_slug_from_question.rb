class RemoveSlugFromQuestion < ActiveRecord::Migration
  def change
    remove_column :questions, :slug
  end
end
