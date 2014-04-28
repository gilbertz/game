class Admin::BannersController < Admin::BaseController

  State = [["下线", 0], ["上线", 1]]

  def index
    @banners = Banner.all
  end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(banner_params)
    @banner.save
    redirect_to admin_banners_path
  end

  def edit
    @banner = Banner.find(params[:id])
  end

  def update
    @banner = Banner.find(params[:id])
    @banner.update_attributes(banner_params)
    @banner.save
    redirect_to admin_banners_path
  end

  def destroy
    @banner = Banner.find(params[:id])
    @banner.destroy
    redirect_to admin_banners_path
  end

  private
  def banner_params
    params.require(:banner).permit(:image_url, :wait, :state)
  end

end