class Admin::HomeController < Admin::BaseController

  skip_before_filter :login_authenticate, :only => [:clear_single_cache, :clear_all_cache]

  def index

  end

  def clear_single_cache
    expire_page "/materials/#{params[:id]}"
    expire_page "/materials/#{params[:id]}/fr/ios"
    expire_page "/materials/#{params[:id]}/fr/andriod"
    render :nothing => true
  end

end
