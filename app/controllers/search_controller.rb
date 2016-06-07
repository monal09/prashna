class SearchController < ApplicationController

	def create
	  query = params[:query]
	  @questions = Question.search(query).paginate(page: params[:page]).order(created_at: :desc)
    render :template => "questions/index"
	end


end
