class UsersController < ApplicationController

  before_action :ensure_anynomous, except: [:myquestions, :show, :follow, :unfollow, :followed_people_questions]
  before_action :set_user, only: [:show, :follow, :unfollow]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to root_path
      flash[:notice] = "Signup successfull!!. A verification
          mail has been sent to your user id #{@user.email}. Please verify your account to continue"
    else
      render action: 'new'
    end

  end

  def myquestions
    @questions = current_user.questions
  end

  def show
    @relationship = current_user.follows.build
  end

  def followed_people_questions
    @followers = current_user.follows
  end

  def verification
    user = User.find_by(verification_token: params[:token])
    if user && user.valid_verification_token?
      user.verify!
      sign_in(user)
      flash[:notice] = "You have been successfully logged in and #{CONSTANTS["initial_credit_points"]} credits have been added to your account"
    else
      flash[:notice] = "Invalid verification token"
    end

    redirect_to root_path
  end


  def follow
    @relationship = current_user.follows.build(followed_id: params[:followed_id])
    if @relationship.save
      redirect_to user_path(params[:followed_id])
    else
      render "show"
    end
  end

  def unfollow
    @relationship = current_user.follows.find_by(followed_id: params[:followed_id])
    if @relationship.destroy
      redirect_to :back
    else
      render "show"
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :email, :password_confirmation)
  end


end
