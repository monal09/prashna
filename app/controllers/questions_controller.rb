class QuestionsController < ApplicationController

  before_action :set_question, only: [:show, :edit, :update, :publish, :unpublish]
  before_action :authenticate, except: [:show, :index]
  before_action :check_visibilty, only: :show
  before_action :check_privelage_for_editing, only: [:edit, :update]

  def index
    @questions = Question.unoffensive.paginate(page: params[:page]).order(published_at: :desc)
  end

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to question_path(@question), notice: "Question successfully added"
    else
      render action: "new"
    end
  end

  def show
    @answers = @question.answers.order(upvotes: :desc)
    @answer = @question.answers.build
    @comment = Comment.new
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to question_path(@question), notice: "Question successfully updated. "
    else
      render action: "edit"
    end
  end

  def publish
    @published = @question.publish
  end

  def unpublish
    @unpublished = @question.unpublish
  end

  def new_question_loader
    if params[:topicparams].present? && params[:questionparams].present?
      @questions = Question.search_by_topic_and_title(params[:time], params[:topicparams], params[:questionparams])
    elsif params[:topicparams].present? && params[:questionparams].blank?
      @questions = Question.search_by_topic(filter_parameter.to_i, params[:time])
    elsif params[:topicparams].blank? && params[:questionparams].present?
      @questions = Question.search_by_question( params[:time], params[:questionparams])
    else
      @questions = Question.published_after(params[:time])
    end
  end

  def following_people_questions
    @questions = Question.visible.submitted_by(current_user.follow_ids)
  end

  private

  def question_params
    params.require(:question).permit(:title, :content, :published, :pdf, :associated_topics)
  end

  def check_visibilty
    redirect_to root_path, notice: "You are not allowed to access this question." unless can_view_question?(@question, current_user)

  end

  def set_question
    @question = Question.find(params[:id])
    if @question.nil?
      redirect_to root_path, notice: "No such question exists"
    end

  end

  def check_privelage_for_editing
    redirect_to root_path, notice: "Question can'tbe edited. You are either not he owner of the question or the question has associated comments and answers." unless  can_edit_question?(@question, current_user)
  end
end
