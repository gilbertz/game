class Admin::UsersController < Admin::BaseController

  def index
    limit = 20
    limit = params[:limit].to_i if params[:limit]
    cond = '1=1'
    cond += " and name like '%#{params[:q]}%'" if params[:q]
    @users = User.where(cond).order('created_at desc').page(params[:page]).per(limit)
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
