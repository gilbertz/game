class Custom::WelcomeController < Custom::CustomController


  def index
    cond = "1=1"
    cond += " and category_id=#{params[:cid]}" if params[:cid]
    cond += " and user_id = 1"

    @materials = Material.includes(:category).where(cond).order('id desc').page(params[:page])
  end

  def custom
    @material = Material.find(params[:id])
  end


end
