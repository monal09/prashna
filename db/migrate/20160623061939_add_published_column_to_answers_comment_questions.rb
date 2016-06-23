class AddPublishedColumnToAnswersCommentQuestions < ActiveRecord::Migration
  def change
    add_column :answers, :admin_unpublished, :boolean, default: false
    add_column :questions, :admin_unpublished, :boolean, default: false
    add_column :comments, :admin_unpublished, :boolean, default: false
  end
end
