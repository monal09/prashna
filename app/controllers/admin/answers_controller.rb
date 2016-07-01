class Admin::AnswersController < Admin::BaseController

  before_action :set_answer, only: [:unpublish, :publish]
  before_action :unpublish_if_published, only: :unpublish
  before_action :publish_if_unpublished, only: :publish

  def index
    @answers = Answer.all.includes(:questions, :users).paginate(page: params[:page])
  end

  def publish
    @answer.admin_unpublished = false
    if @answer.save
      redirect_to :back, notice: "Answer successfully published."
    else
      redirect_to :back, notice: "Failed to publish."
    end
  end

  def unpublish
    @answer.admin_unpublished = true
    if @answer.save
      redirect_to :back, notice: "Answer successfully unpublished."
    else
      redirect_to :back, notice: "Failed to unpublish."
    end
  end

  private

  def set_answer
    @answer = Answer.find_by(id: params[:id])
    redirect_to root_path, notice: "No such answer exists" unless @answer
  end

  def unpublish_if_published
    redirect_to root_path, notice: "This answer is already unpublished" if @answer.admin_unpublished?
  end

  def publish_if_unpublished
    redirect_to root_path, notice: "This answer is already published" unless @answer.admin_unpublished?
  end

end
