class UsersController < ApplicationController

  #FIXME_AB: use only, would be more readable now ;done
  before_action :ensure_anynomous, only: [:create, :new]
  # before_action :ensure_anynomous, except: [:myquestions, :show, :follow, :unfollow, :followed_people_questions, :edit, :update]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :check_privelage_for_editing, only: [:edit, :update]
  before_action :check_for_duplicate_relationship, only: [:follow]
  before_action :check_for_existence, only: :unfollow 

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

  def edit
  end

  def update
    if @user.update(user_edit_params)
      redirect_to user_path(@user), notice: "User successfully updated. "
    else
      render action: "edit"
    end
  end

  def myquestions
    @questions = current_user.questions
  end

  def show
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
    #FIXME_AB: users/flollow_id/follow users/id/unfollow
    #FIXME_AB: you need a before action to check that user is not following him already. In succh case redirec to back with a message;done
    @relationship = current_user.active_relationships.build(followed_id: params[:followed_id])
    if @relationship.save
      #FIXME_AB: notice?;done
      redirect_to user_path(params[:followed_id]), notice: "You are now following this user."
    else
      #FIXME_AB: redirect to back hence you won't need to have set_user;done
      redirect_to :back, notice: "Failed to follow. Please try again later."
    end
  end

  def unfollow
    #FIXME_AB: need to check if user is actually following the other user.;done
    @relationship = current_user.active_relationships.find_by(followed_id: params[:followed_id])
    if @relationship.destroy
      redirect_to :back, notice: "You have unfollowed."
    else
      redirect_to :back, notice: "Failed to un follow. Please try again later."
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    redirect_to root_path, notice: "No such user exists." unless @user
    #FIXME_AB: what if not found; done
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :email, :password_confirmation)
  end

  def user_edit_params
    params.require(:user).permit(:first_name, :last_name, :associated_topics, :image)
  end

  def check_privelage_for_editing
    redirect_to root_path, notice: "You can't edit other user profile." unless  can_edit_user?(@user, current_user)
  end

  def check_for_duplicate_relationship
    redirect_to root_path, notice: "You are already following this user." if current_user.follows.where(id: params[:followed_id]).exists?
  end

  def check_for_existence
    redirect_to root_path, notice: "You don't follow any such user." unless current_user.follows.where(id: params[:followed_id]).exists?
  end


end
