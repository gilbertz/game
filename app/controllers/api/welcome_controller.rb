class Api::WelcomeController < Api::ApiController

  def banners
    @banners = Banner.where(:state => 1).order("id desc").all
  end

  def game_types
    if params[:all] == "1"
      @game_types = GameType.all
    else
      @game_types = GameType.where("type_image is not null").all
    end
  end

  def index
      cond = "1=1"
      cond += " and `category_id` = #{params[cid]}" if params[:cid]
      cond += " and `categories`.`game_type_id` = #{params["game_type_id"]}" unless params["game_type_id"].blank?
      materials = Material.includes(:images).joins(:category).where(cond).where(state: 1)

      if params[:order] == "hot"
        materials = materials.order('redis_pv desc')
      elsif params[:order] == "recommend"
        materials = materials.order('redis_wx_share_pyq desc')
      else
        materials = materials.order('materials.id desc')
      end

      per_page = params[:per_page] || 12

      @materials = materials.page(params[:page]).per(per_page)
  end

  def document

    render :layout => false
  end

end