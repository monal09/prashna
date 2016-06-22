class Api::FeedsController < ApplicationController

  before_action :set_user, only: :my_feed

  def my_feed
    @topics = @user.topics.includes(questions: [ :comments, { answers: :comments}]) if @user
  end

  private

  def set_user
    @user = User.find_by(authorization_token: params[:authorization_token])
  end

end
