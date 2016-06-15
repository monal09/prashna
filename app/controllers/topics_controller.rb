class TopicsController < ApplicationController

  before_action :set_topic, only: :questions

  def questions
    @questions = @topic.questions.published.paginate(:page => params[:page]).order(published_at: :desc)
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
