module NORMAL

  module Cards

    class CardAPI < Grape::API


      version 'v1'

      get '/text_api' do

        Party.qy_pay(nil,nil,800)
        {"result" => 749792}
      end



    end



  end

end