class Qq::WelcomeController < Qq::QqController

  Api_domain = "openapi.tencentyun.com"
  Api_url = "http://#{Api_domain}/"


  App_id = "1101255082"
  App_key = "rwgnIjHffqSXS4D3"

  def index
    if params[:index].to_i == 10
      render :template => "qq/welcome/index", :layout => false
      return
    end

    unless params[:material_id].blank?
      @material = Material.find params[:material_id]

      render :template => "qq/welcome/show_ajax"
    else
      render :template => "qq/welcome/gabrielecirulli", :layout => false
    end

    #p = pre_format_p
    #sig = sign(p, App_key)
    #p.merge!(sig: sig)
    #@res = RestClient.get(Api_url + "v3/user/get_info", p)
  end

  def load
    render :layout => false
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
