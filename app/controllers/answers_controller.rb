class AnswersController < ApplicationController

  before_action :authenticate, only: [:create, :upvote, :downvote]
  before_action :set_question, only: :create
  before_action :set_answer, only: [:upvote, :downvote]


  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice: "Answer successfully added."
    else
      @answers = @question.answers.order(created_at: :desc)
      @comment = Comment.new
      flash.now[:errors] = "Couldn't save your answer, please fix the errors."
      render "questions/show"
    end
  end

  def upvote
    @upvote = @answer.votes.create(upvote: true, user_id: current_user.id)
    @answer.reload
  end

  def downvote
    @downvote = @answer.votes.create(upvote: false, user_id: current_user.id)
    @answer.reload
  end

  private

  def answer_params
    params.require(:answer).permit(:content)
  end

  def set_question
    @question = Question.published.find_by(id: params[:question_id].to_i)
    redirect_to root_path, notice: "This question does't exist or is not published" unless @question
  end

  def set_answer
    @question = Question.published.find_by(id: params[:question_id])
    @answer = @question.answers.where(id: params[:id]).first if @question
    redirect_to root_path, notice: "no such answer exits" unless @answer
  end


end
