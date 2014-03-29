class Qq::WelcomeController < Qq::QqController

  Api_domain = "openapi.tencentyun.com"
  Api_url = "http://#{Api_domain}/"


  App_id = "1101255082"
  App_key = "rwgnIjHffqSXS4D3"

  def index
    @material_id = 41

    unless params[:app_custom].blank?
      @material_id = params[:app_custom].split("=").last
    end

    unless params[:material_id].blank?
      @material_id = params[:material_id]
    end

    @material = Material.find @material_id

    if @material.blank?
      @material = Material.find(319)
    end

    @from = "qq"

    if params[:layouts] == "0"
      #render :template => "qq/welcome/load", layout: false
      render :template => "materials/show", layout: false
    else
      render :template => "materials/show", layout: "qq/layouts/qq_game"
    end

    #p = pre_format_p
    #sig = sign(p, App_key)
    #p.merge!(sig: sig)
    #@res = RestClient.get(Api_url + "v3/user/get_info", p)
  end

  def load
    render :layout => false
  end

  def recent_material
    @recent_materials = Material.where(:is_qq => 1).order("id desc").limit(5)
    render :layout => false
  end

  def hot_material
    @hot_materials = Material.where(:is_recommend_to_qq => 1).order("id desc").limit(4)
    render :layout => false
  end


  def test
    render :template => "qq/welcome/test1", :layout => false
  end


  private
  def pre_format_p
    {
        openid: params[:openid] || "",
        openkey: params[:openkey] || "",
        pf: params[:pf] || "",
        appid: App_id
    }
  end


  def sign(p, secret)
    method = "/v3/user/get_info"
    str1 = "#{CGI::escape(method)}"
    str2 = CGI::escape(p.sort.collect{|i| i.join("=")}.join("&"))
    str = "GET&#{str1}&#{str2}"

    secret = "#{secret}&"
    digest = OpenSSL::Digest::Digest.new('sha1')
    Base64.encode64(OpenSSL::HMAC.digest(digest, secret, str)).chomp
  end


end
