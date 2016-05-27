class UsersController < ApplicationController

  before_action :ensure_anynomous

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

  def verification
    user = User.find_by(verification_token: params[:token])
    if user && user.valid_verification_token?
      user.credit_transactions.create(amount: 5, event: :signup, resource_id: user.id,resource_type: user.class)
      sign_in(user)
      user.verify!
      flash[:notice] = "You have been successfully logged in and 5 credits have been added to your account"
    else
      flash[:notice] = "Invalid verification token"
    end

    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :email, :password_confirmation)
  end


end
