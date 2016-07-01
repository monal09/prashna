class Admin::UsersController < Admin::BaseController
  
  before_action :set_user, only: [:disable, :enable, :show]
  before_action :ensure_not_disabling_yourself, only: :disable

  def index
    @users = User.all.paginate(page: params[:page])
  end

  def disable
    @user.disabled = true
    if @user.save
      redirect_to :back, notice: "User successfully disabled"
    else
      redirect_to :back, notice: "Failed to disable user"
    end
  end

  def enable
    @user.disabled = false
    if @user.save
      redirect_to :back, notice: "User successfully enabled"
    else
      redirect_to :back, notice: "Failed to enable user"
    end
  end

  def show
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    redirect_to root_path, notice: "No such user exists" unless @user
  end

  def ensure_not_disabling_yourself
    if @user == current_user
      redirect_to :back, notice: 'Can not disable yourself.'
    end
  end

end
