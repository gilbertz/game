class Admin::ChecksController < Admin::BaseController
  before_action :set_check, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    cond = "1=1"
    cond += " and beaconid=#{params[:beaconid]}" if params[:beaconid]
    cond += " and user_id=#{params[:user_id]}" if params[:user_id]
    cond += " and game_id=#{params[:game_id]}" if params[:game_id]
    limit = 20
    limit = params[:limit].to_i if params[:limit]
    @checks = Check.where(cond).order('created_at desc').page(params[:page]).per(limit)
    respond_with(@checks)
  end

  def show
    respond_with(@check)
  end

  def new
    @check = Check.new
    respond_with(@check)
  end

  def edit
  end

  def create
    @check = Check.new(check_params)
    @check.save
    redirect_to [:admin, :checks]
  end

  def update
    @check.update(check_params)
    redirect_to [:admin, :checks]
  end

  def destroy
    @check.destroy
    redirect_to [:admin, :checks]
  end

  private
    def set_check
      @check = Check.find(params[:id])
    end

    def check_params
      params.require(:check).permit(:beaconid, :user_id, :state, :lng, :lat)
    end
end
