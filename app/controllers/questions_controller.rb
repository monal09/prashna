class QuestionsController < ApplicationController

  before_action :set_question, only: [:show, :edit, :update, :publish, :unpublish]
  before_action :authenticate, except: :show
  before_action :check_visibilty, only: :show
  before_action :check_privelage_for_editing, only: [:edit, :update]

  def index
    @questions = Question.published
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
  end

  def edit
    @question.associated_topics = @question.get_topics_list
  end

  def update
    if @question.update(question_params)
      redirect_to question_path(@question), notice: "Question successfully edited "
    else
      render action: "edit"
    end
  end

  def publish
    @published = @question.publish
    sleep 2
  end

  def unpublish
    @unpublished = @question.unpublish
  end


  private

  def question_params
    params.require(:question).permit(:title, :content, :published, :uploaded_file, :associated_topics)
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
    redirect_to root_path, notice: "Only owner of the question have editing privelages" unless  can_edit_question?(@question, current_user)
  end
end
