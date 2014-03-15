class Qq::WelcomeController < Qq::QqController

  def index
    if params[:index].blank?
      render :template => "qq/welcome/gabrielecirulli", :layout => false
    else
      render :layout => false
    end
  end

end
