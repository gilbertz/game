# encoding: utf-8
class HomeController < ApplicationController

  def index
    #game_type_id = params[:game_type_id] unless params[:game_type_id].blank?
    page = 1
    page = params[:page].to_i if params[:page]
    @next_page = page + 1    

    materials = Material.includes(:images).joins(:category)

    #unless game_type_id.blank?
    #  materials = materials.where("categories.game_type_id=?", params[:game_type_id])
    #end

    materials = materials.where(state: 1).where(:user_id => 1)

    #@current_game_order = "最新内容"
    #unless params[:order].blank?
    #  if params[:order] == "hot"
    #    materials = materials.order('redis_pv desc')
    #    @current_game_order = "人气最高"
    #  elsif params[:order] == "recommend"
    #    materials = materials.order('redis_wx_share_pyq desc')
    #    @current_game_order = "热门推荐"
    #  end
    #else
      materials = materials.order('id desc')
    #end

    @materials = materials.page( page ).per(12)

    #@game_types = GameType.all
    #@game_type = GameType.find(game_type_id) if game_type_id
    #@current_game_type = "全部分类"
    #@current_game_type = @game_type.game_type if @game_type

    render 'index', :layout => nil
  end

  def r
    redirect_to params[:url]
  end

  def redirect
    redirect_to "/"
  end

end
