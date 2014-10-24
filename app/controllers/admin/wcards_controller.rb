class Admin::WcardsController < Admin::BaseController
  def index
    @wcards = Wcard.order("id desc").page(params[:page])
  end

  def new
    @wcard = Wcard.new
  end

  def create
    wcard = Wcard.new wcard_params
    wcard.save
    redirect_to [:wcardmin, :wcards]
  end

  def clone
    wcard = ::Wcard.find params[:id] 
    ::Wcard.create wcard.attributes.except!("created_at", "id")
    redirect_to [:wcardmin,:wcards]
  end

  def edit
    @wcard = Wcard.find params[:id]
  end

  def update
    @wcard = Wcard.find params[:id]
    #@wcard.materials.each do |mate|
    #  expire_fragment(mate)
    #end
    @wcard.update_attributes wcard_params
    redirect_to [:edit,:admin,@wcard]
  end

 
  def update_state
    wcard = Wcard.find params[:id]
    wcard.invert_state
    render json: {msg: 'ok', val: wcard.reload.state}
  end



  def destroy
    @wcard = Wcard.find params[:id]
    arg = @wcard.destroy ? 'ok' : 'err'
    render json: {msg: arg}
  end

  def show_stat
    id = params[:id]
    key = "wcard_show_#{id}"
    $redis.incr(key)
    render :nothing => true 
  end

  
  def click_stat
    id = params[:id]
    key = "wcard_click_#{id}"
    $redis.incr(key)
    render :nothing => true
  end


  private
  def wcard_params
    params.require(:wcard).permit(:title,:content,:cover,:cid,:bid,:state, :user_id, :url, :thumb)
  end
end
