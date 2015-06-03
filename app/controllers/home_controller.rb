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

    max_id = Material.maximum('id')
    if params[:type]
      materials = materials.where(state: 1).where("categories.game_type_id=?", 7)
    else
      materials = materials.where(state: 1).where("materials.id <= #{max_id}")
    end

    materials = materials.order('id desc')

    unless params[:game]
      @materials = materials.page( page ).per(12)
    else
      @materials = materials
    end

    render 'index', :layout => nil
  end

  
  def list
    page = 1
    page = params[:page].to_i if params[:page]
    @next_page = page + 1
    limit = 20

    materials = Material.includes(:images).joins(:category)
    max_id = Material.maximum('id')
    if params[:type]
      materials = materials.where(state: 1).where("categories.game_type_id=?", 7)
    else
      materials = materials.where(state: 1).where("materials.id <= #{max_id}")
    end

    materials = materials.order('id desc')

    unless params[:game]
      @materials = materials.page( page ).per( limit )
    else
      @materials = materials
    end

    render 'list', :layout => nil
  end


  def ibeacon
    @ibeacon = Ibeacon.find_by_url( params[:url] )
    burls = Burl.where(:beaconid => @ibeacon.id).where(:state => 1) if @ibeacon
    burl = burls.sample(1)[0] if burls
    redirect_to burl.url    
  end


  def home
    page = 1
    page = params[:page].to_i if params[:page]
    @next_page = page + 1
    limit = 10
    
    @beacon = Ibeacon.find_by_url( params[:beaconid] )
    @materials = []
    if @beacon 
      bgames = Bgame.where(:beaconid => @beacon.id).order('created_at desc').page( page ).per( limit )
      @materials = bgames.map{|b| b.get_game }
      Material.current_material = @materials.first
    end
    render 'o2o', :layout => nil 
  end


  def o2o
    page = 1
    page = params[:page].to_i if params[:page]
    @next_page = page + 1
    limit = 10

    materials = Material.includes(:images).joins(:category)
    materials = materials.where(rrr: 1)
    materials = materials.order('id desc')

    @materials = materials.page( page ).per( limit )

    render 'o2o', :layout => nil
  end



  def read
    page = 1
    limit = 8
    page = params[:page].to_i if params[:page]
    limit = params[:limit].to_i if params[:limit]
    @next_page = 0

    @articles = Material.where(:category_id => 279).order('created_at desc').page(page).per(limit)
    @next_page = page + 1 if @articles.length >= limit
    render 'articles', :layout => false
  end


  def add_weixin_url
    if params[:url]
      Material.create_by_web(params[:url])      
    end
    render :text => "succ!!" 
  end

  def r
    redirect_to params[:url]
  end

  def redirect
    redirect_to "/"
  end

end
