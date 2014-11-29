class Admin::MaterialsController < Admin::BaseController
  before_filter :clear_rubbish, only: [:update,:destroy]
  def index
    cond = "1=1"
    cond += " and category_id=#{params[:cid]}" if params[:cid]
    cond += " and user_id = 1"
    cond += " and name like '%#{params[:q]}%'" if params[:q]
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
    if material_params[:link].blank?
      material = Material.new material_params
      material.save
    else
      material = Material.create_by_web(material_params[:link])
    end
    redirect_to [:admin,:materials]
  end

  def edit
    @material = Material.find_by_url params[:id]
    @material = Material.find params[:id] unless @material
  end

  def update
    if material_params[:link].blank?
      @material.update_attributes material_params
    else
      @material = Material.create_by_web(material_params[:link])
    end

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

  def wx_clone
    material = Material.find params[:id]
    material.wx_cloning(true)
    redirect_to [:admin,:materials]
  end

  def destroy
    @material.destroy
    render nothing: true
  end
  private
  def material_params
    params.require(:material).permit(:link, :name,:description,:category_id,:wx_appid,:wxdesc,:wx_tlimg, :thumb, :wx_url,:share_url, :wx_title, :wx_ln, :advertisement, :advertisement_1)
  end

  def clear_rubbish
    @material = Material.find params[:id]
    clear_page(@material)
  end

end
