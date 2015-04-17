class Admin::IbeaconsController < Admin::BaseController
  before_action :set_ibeacon, only: [:show, :edit, :update, :destroy]

   State = [["下线", 0], ["上线", 1], ["社区", 2]]

  respond_to :html

  def index
    @ibeacons = Ibeacon.all
    # respond_with(@ibeacons)
    redirect_to admin_ibeacons_path
  end

  def show
    # respond_with(@ibeacon)
    redirect_to admin_ibeacons_path
  end

  def new
    @ibeacon = Ibeacon.new
    respond_with(@ibeacon)
  end

  def edit
  end

  def create
    @ibeacon = Ibeacon.new(ibeacon_params)
    @ibeacon.save
    #respond_with(@ibeacon)
    redirect_to admin_ibeacons_path
  end

  def update
    @ibeacon.update(ibeacon_params)
    #respond_with(@ibeacon)
    redirect_to admin_ibeacons_path
  end

  def destroy
    @ibeacon.destroy
    #respond_with(@ibeacon)
    redirect_to admin_ibeacons_path
  end

  private
    def set_ibeacon
      @ibeacon = Ibeacon.find(params[:id])
    end

    def ibeacon_params
      params.require(:ibeacon).permit(:name, :user_id, :state, :remark, :url, :provider, :uid)
    end
end
