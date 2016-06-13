class CommentsController < ApplicationController

  before_action :authenticate
  before_action :check_commentable_validity, only: :create

  def new
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :commentable_type, :commentable_id)
  end

  def check_commentable_validity
    if params[:comment][:commentable_type] == "Question"
      commentable = Question.published.find_by(id: params[:comment][:commentable_id])
    else
      commentable = Answer.find_by(id: params[:comment][:commentable_id])
    end
    redirect_to root_path, alert: "You can not comment here" unless commentable
  end


end
