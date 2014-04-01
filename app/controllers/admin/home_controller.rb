class Admin::HomeController < Admin::BaseController

  skip_before_filter :login_authenticate, :only => [:clear_single_cache, :clear_all_cache]

  def index

  end


  # admin home clear all / admin materials clear_page 更换服务器需要修改两处请求地址
  def clear_all
    l_ip = Socket.ip_address_list.collect{|i| i.ip_address}

    cache_path = "#{Rails.root}/public/materials"
    FileUtils.rm_r(cache_path) if Dir.exist?(cache_path)

    if l_ip.include? "203.195.191.203"
      res = RestClient.get("http://203.195.186.54:4002/admin/home/clear_all_cache")
    else
      res = RestClient.get("http://203.195.191.203:4002/admin/home/clear_all_cache")
    end

    redirect_to :back
  end

  def clear_single_cache
    expire_page "/materials/#{params[:id]}"
    expire_page "/materials/#{params[:id]}/fr/ios"
    expire_page "/materials/#{params[:id]}/fr/andriod"
    render :nothing => true
  end

  def clear_all_cache
    cache_path = "#{Rails.root}/public/materials"
    FileUtils.rm_r(cache_path) if Dir.exist?(cache_path)
    render :nothing => true
  end

end
