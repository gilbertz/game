class Custom::MaterialsController < Custom::CustomController

  def index
    cond = "1=1"
    cond += " and category_id=#{params[:cid]}" if params[:cid]
    cond += " and user_id = #{current_user.id}"
    @materials = Material.includes(:category).where(cond).order('id desc').page(params[:page])
  end

  def new
    @material = Material.new
  end

  def create
    material = Material.new material_params
    material.save
    redirect_to [:custom,:materials]
  end

  def edit
    @material = Material.find params[:id]
  end

  def update
    material = Material.find(params[:id])

    if params[:clone].to_i == 1
      material = material.custom_clone
      material.update_attributes material_params.merge(:user_id => current_user.id)
    else

      unless can? material
        render :text => "limited"
        return
      end

      material.update_attributes material_params
    end

    material.save

    redirect_to [:custom,:materials]
  end

  def update_state
    material = Material.find params[:id]
    material.invert_state 
    render json: {msg: 'ok', val: material.reload.cn_state}
  end

  private
  def material_params
    params.require(:material).permit(:name,:description,:wx_appid,:wxdesc,:wx_tlimg,:wx_url,:wx_title, :wx_ln, :advertisement, :advertisement_1)
  end

end
