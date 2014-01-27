class Admin::MaterialsController < Admin::BaseController
  before_filter :clear_rubbish, only: [:update,:destroy]
  def index
    @materials = Material.includes(:category).order('id desc')
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
    params.require(:material).permit(:name,:description,:category_id,:wx_appid,:wxdesc,:wx_tlimg,:wx_url,:wx_title)
  end

  def clear_rubbish
    @material = Material.find params[:id]
    expire_fragment(@material)
  end
end
