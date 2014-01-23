class Admin::UsersController < Admin::BaseController

  def index
    @users = User.order('id desc')
  end

  def new
    @user = User.new
  end

  def create
    user = User.new user_params
    user.save
    redirect_to [:admin,:root]
  end

  private
  def user_params
    params.require(:user).permit(:name,:password,:password_confirmation)
  end
end
