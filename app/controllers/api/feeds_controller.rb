class Api::FeedsController < ApplicationController

  before_action :set_user, only: :my_feed

  def my_feed
    @topics = @user.topics
  end

  private

  def set_user
    @user = User.find_by(authorization_token: params[:authorization_token])
    redirect_to root_path, notice: "No such user exists" unless @user
  end

end
