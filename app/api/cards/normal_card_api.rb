module NORMAL

  module Cards

    class CardAPI < Grape::API


      version 'v1'

      get '/text_api' do

        # Party.qy_pay(7,nil,1,"送钱了")

        r = Redpack.find_by(beaconid: 23)
        # r.qy_pay(7, money=nil)
        # r.send_pay(7,23, 1,nil)

        r.send_pay(7,23, 0,nil)



        {"result" => 749792}
      end



    end



  end

end
