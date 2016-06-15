class CommentsController < ApplicationController

  before_action :authenticate
  before_action :check_commentable_validity, only: :create
  before_action :set_comment, only: [:upvote, :downvote]

  def new
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.save
  end

  def upvote
    @upvote = @comment.votes.create(upvote: true, user_id: current_user.id)
    @comment.reload
  end

  def downvote
    @downvote = @comment.votes.create(upvote: false, user_id: current_user.id)
    @comment.reload
  end

  private

  def set_comment
    @comment = Comment.find_by(id: params[:id])
    redirect_to root_path, notice: "no such answer exits" unless @comment
  end

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
