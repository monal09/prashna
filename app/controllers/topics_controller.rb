class TopicsController < ApplicationController

  before_action :set_topic, only: :questions

  def questions
    if params[:query].present?
      @questions = Question.search_question_with_topic(params[:query], @topic.id).paginate(:page => params[:page]).order(published_at: :desc)
    else
      @questions = @topic.questions.published.paginate(:page => params[:page]).order(published_at: :desc)
    end
    render :template => "questions/index"
  end

  private

  def set_topic
    @topic = Topic.find_by( id: params[:id] )
    if @topic.nil?
      redirect_to root_path, notice: "This topic does not exist"
    end
  end

end
