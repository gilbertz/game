class Admin::AdsController < Admin::BaseController
  def index
    @ads = Ad.order("id desc").page(params[:page])
  end

  def new
    @ad = Ad.new
  end

  def create
    ad = Ad.new ad_params
    ad.save
    redirect_to [:admin, :ads]
  end

  def clone
    ad = ::Ad.find params[:id] 
    ::Ad.create ad.attributes.except!("created_at", "id")
    redirect_to [:admin,:ads]
  end

  def edit
    @ad = Ad.find params[:id]
  end

  def update
    @ad = Ad.find params[:id]
    #@ad.materials.each do |mate|
    #  expire_fragment(mate)
    #end
    @ad.update_attributes ad_params
    redirect_to [:edit,:admin,@ad]
  end

  def destroy
    @ad = Ad.find params[:id]
    arg = @ad.destroy ? 'ok' : 'err'
    render json: {msg: arg}
  end

  def show_stat
    id = params[:id]
    key = "ad_show_#{id}"
    $redis.incr(key)
    render :nothing => true 
  end

  
  def click_stat
    id = params[:id]
    key = "ad_click_#{id}"
    $redis.incr(key)
    render :nothing => true
  end


  private
  def ad_params
    params.require(:ad).permit(:title,:desc,:img,:click,:start_date,:end_date, :on)
  end
end
