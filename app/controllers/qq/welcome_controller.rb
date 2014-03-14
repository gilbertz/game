class Qq::WelcomeController < Qq::QqController

  def index

    render :template => "qq/welcome/gabrielecirulli", :layout => false
  end

end
