class Admin::MaterialsController < Admin::BaseController
  before_filter :clear_rubbish, only: [:update,:destroy]
  def index
    cond = "1=1"
    cond = "category_id=#{params[:cid]}" if params[:cid]
    @materials = Material.includes(:category).where(cond).order('id desc').page(params[:page])
  end

  def recommend_to_qq
    material = Material.find(params[:id])
    material.is_qq = 1
    material.save
    redirect_to :back
  end

  def recommend_game
    material = Material.find(params[:id])
    material.is_recommend_to_qq = 1
    material.save
    redirect_to :back
  end

  def new
    @material = Material.new
  end

  def create
    material = Material.new material_params
    material.save
    redirect_to [:admin,:materials]
  end

  def edit
    @material = Material.find params[:id]
  end

  def update
    @material.update_attributes material_params

    clear_page(@material)

    redirect_to [:admin,:materials]
  end

  def update_state
    material = Material.find params[:id]
    material.invert_state 
    render json: {msg: 'ok', val: material.reload.cn_state}
  end

  def clone
    material = Material.find params[:id]
    material.cloning(true)
    redirect_to [:admin,:materials]
  end

  def destroy
    @material.destroy
    render nothing: true
  end
  private
  def material_params
    params.require(:material).permit(:name,:description,:category_id,:wx_appid,:wxdesc,:wx_tlimg,:wx_url,:wx_title, :wx_ln, :advertisement, :advertisement_1)
  end

  def clear_rubbish
    @material = Material.find params[:id]
    clear_page(@material)
  end

  def clear_page(material)

    puts "-----begin---clear-----cache---"

    l_ip = Socket.ip_address_list.collect{|i| i.ip_address}

    cache_path = "#{Rails.root}/public/materials"
    FileUtils.rm_r(cache_path) if Dir.exist?(cache_path)

    if l_ip.include? "203.195.191.203"
      res = RestClient.get("http://203.195.186.54:4002/admin/home/clear_single_cache/#{material.id}")
    else
      res = RestClient.get("http://203.195.191.203:4002/admin/home/clear_single_cache/#{material.id}")
    end

  end

end
