class Admin::RedpacksController < Admin::BaseController
  skip_before_filter :verify_authenticity_token
  before_action :set_redpack, only: [:show, :edit, :update, :destroy]

  State = [["下线", 0], ["上线", 1]]

  respond_to :html

  def index
    @redpacks = Redpack.all
    respond_with(@redpacks)
  end

  def show
    respond_with(@redpack)
  end

  def new
    @redpack = Redpack.new
    respond_with(@redpack)
  end

  def edit
    @redpack = Redpack.find params[:id]
  end

  def create
    @redpack = Redpack.new(redpack_params)
    @redpack.save
    redirect_to [:admin, :redpacks]
  end

  def update
    @redpack.update(redpack_params)
    redirect_to [:admin, :redpacks] 
  end

  def destroy
    @redpack.destroy
    redirect_to [:admin, :redpacks] 
  end

  private
    def set_redpack
      @redpack = Redpack.find(params[:id])
    end

    def redpack_params
      params.require(:redpack).permit(:beaconid, :app_id, :store, :state, :shop_id, :sender_name, :wishing, :action_title, :action_remark, :min, :max, :suc_url, :fail_url, :amount, :each_max, :each_num, :probability, :password, :virtual_num, :start_time, :end_time)
    end
end
