class Admin::WshowsController < Admin::BaseController
  def index
    @wshows = Wshow.order("id desc").page(params[:page])
  end

  def new
    @wshow = Wshow.new
  end

  def create
    wshow = Wshow.new wshow_params
    wshow.save
    redirect_to [:wshowmin, :wshows]
  end

  def clone
    wshow = ::Wshow.find params[:id] 
    ::Wshow.create wshow.attributes.except!("created_at", "id")
    redirect_to [:admin,:wshows]
  end

  def edit
    @wshow = Wshow.find params[:id]
  end

  def update
    @wshow = Wshow.find params[:id]
    #@wshow.materials.each do |mate|
    #  expire_fragment(mate)
    #end
    @wshow.update_attributes wshow_params
    redirect_to [:edit,:admin,@wshow]
  end

  def destroy
    @wshow = Wshow.find params[:id]
    arg = @wshow.destroy ? 'ok' : 'err'
    render json: {msg: arg}
  end

  def show_stat
    id = params[:id]
    key = "wshow_show_#{id}"
    $redis.incr(key)
    render :nothing => true 
  end

  
  def click_stat
    id = params[:id]
    key = "wshow_click_#{id}"
    $redis.incr(key)
    render :nothing => true
  end


  private
  def wshow_params
    params.require(:wshow).permit(:title,:content,:cover,:cid,:bid,:state, :user_id, :url, :thumb)
  end
end
