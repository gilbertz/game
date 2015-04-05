class Admin::BurlsController < Admin::BaseController
  before_action :set_burl, only: [:show, :edit, :update, :destroy]
  State = [["下线", 0], ["上线", 1]]

  respond_to :html

  def index
    @burls = Burl.all
    respond_with(@burls)
  end

  def show
    respond_with(@burl)
  end

  def new
    @burl = Burl.new
    respond_with(@burl)
  end

  def edit
  end

  def create
    @burl = Burl.new(burl_params)
    @burl.save
    #respond_with(@burl)
    redirect_to admin_burls_path
  end

  def update
    @burl.update(burl_params)
    #respond_with(@burl)
    redirect_to admin_burls_path
  end

  def destroy
    @burl.destroy
    #respond_with(@burl) 
    redirect_to admin_burls_path
  end

  private
    def set_burl
      @burl = Burl.find(params[:id])
    end

    def burl_params
      params.require(:burl).permit(:url, :beaconid, :weight, :state, :pv, :uv, :title, :img, :remark)
    end
end
