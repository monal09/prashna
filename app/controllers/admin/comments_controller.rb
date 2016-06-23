class Admin::CommentsController < Admin::BaseController

  include CheckAdmin
  before_action :admin_privelage_required
  before_action :set_comment, only: [:unpublish, :publish]
  before_action :unpublish_if_published, only: :unpublish
  before_action :publish_if_unpublished, only: :publish

  def index
    @comments = Comment.all.paginate(page: params[:page])
  end

  def publish
    @comment.admin_unpublished = false
    if @comment.save
      redirect_to :back, notice: "comment successfully published."
    else
      redirect_to :back, notice: "Failed to publish."
    end
  end

  def unpublish
    @comment.admin_unpublished = true
    if @comment.save
      redirect_to :back, notice: "comment successfully unpublished."
    else
      redirect_to :back, notice: "Failed to unpublish."
    end
  end

  private

  def set_comment
    @comment = Comment.find_by(id: params[:id])
    redirect_to root_path, notice: "No such comment exists" unless @comment
  end

  def unpublish_if_published
    redirect_to root_path, notice: "This comment is already unpublished" if @comment.admin_unpublished?
  end

  def publish_if_unpublished
    redirect_to root_path, notice: "This comment is already published" unless @comment.admin_unpublished?
  end

end
