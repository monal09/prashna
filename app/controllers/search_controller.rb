class SearchController < ApplicationController

  def create
    query = params[:query]

    if params[:search_topic].present?
      @questions = Question.search_question_with_topic(query, params[:search_topic]).paginate(page: params[:page]).order(published_at: :desc)
    else
      @questions = Question.search_question(query).paginate(page: params[:page]).order(published_at: :desc)
    end

    render :template => "questions/index"
  end


end
