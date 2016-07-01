class Admin::QuestionsController < Admin::BaseController

  before_action :set_question, only: [:unpublish, :publish, :show]
  before_action :unpublish_if_published, only: :unpublish
  before_action :publish_if_unpublished, only: :publish

  def index
    #FIXME_AB: check log wwhere you can eager load
    @questions = Question.published.all.includes(:user).paginate(page: params[:page])
  end

  def publish
    @question.admin_unpublished = false
    if @question.save
      redirect_to :back, notice: "question successfully published."
    else
      redirect_to :back, notice: "Failed to publish."
    end
  end

  def unpublish
    @question.admin_unpublished = true
    if @question.save
      redirect_to :back, notice: "question successfully unpublished."
    else
      redirect_to :back, notice: "Failed to unpublish."
    end
  end

  def show
    @answers = @question.answers
  end

  private

  def set_question
    @question = Question.find_by(id: params[:id])
    redirect_to root_path, notice: "No such question exists" unless @question
  end

  def unpublish_if_published
    redirect_to root_path, notice: "This question is already unpublished" if @question.admin_unpublished?
  end

  def publish_if_unpublished
    redirect_to root_path, notice: "This question is already published" unless @question.admin_unpublished?
  end

end
