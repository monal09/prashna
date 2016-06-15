class QuestionsController < ApplicationController

  before_action :set_question, only: [:show, :edit, :update, :publish, :unpublish]
  before_action :authenticate, except: [:show, :index]
  before_action :check_visibilty, only: :show
  before_action :check_privelage_for_editing, only: [:edit, :update]

  def index
    @questions = Question.published.paginate(page: params[:page]).order(published_at: :desc)
  end

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(question_params)
    #FIXME_AB: uploaded file is not visible; done
    #FIXME_AB: if question is not saved, topics do not appear in form; done
    if @question.save
      redirect_to question_path(@question), notice: "Question successfully added"
    else
      render action: "new"
    end

  end

  def show
    #FIXME_AB: comment ordering is diffenent fix it.;done
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
    if params[:filter].present?
      filter_type = params[:filter].split("+").first
      filter_parameter = params[:filter].split("+").last
      @questions = find_new_questions(filter_type, filter_parameter)
    else
      @questions = Question.published_after_reload(params[:time])
    end

  end

  def find_new_questions( filter_type, filter_parameter)
    if filter_type == "search_query"
      @questions =  Question.published_after_reload(params[:time]).search(filter_parameter)
    elsif filter_type == "topic"
      @topic = Topic.find_by(id: filter_parameter.to_i)
      @questions = @topic.questions.published_after_reload(params[:time])
    end
    return @questions
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
    redirect_to root_path, notice: "Only owner of the question have editing privelages" unless  can_edit_question?(@question, current_user)
  end
end
