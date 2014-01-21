class Admin::MaterialsController < Admin::BaseController
  def index
    @materials = Material.order('id desc')
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
    material = Material.find params[:id]
    material.update_attributes material_params
    redirect_to [:admin,:materials]
  end

  def clone
    material = Material.find params[:id]
    material.cloning(true)
    redirect_to [:admin,:materials]
  end

  def destroy
    Material.find(params[:id]).destroy
    render nothing: true
  end
  private
  def material_params
    params.require(:material).permit(:title,:category_id,:wx_appid,:wx_desc,:wx_tlimg,:wx_url,:wx_title)
  end
end
