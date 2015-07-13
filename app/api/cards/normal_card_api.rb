module NORMAL

  module Cards

    class CardAPI < Grape::API


      version 'v1'

      get '/text_api' do
        p request
        p "rurl = "+params["rurl"]
        # Party.qy_pay(7,nil,1,"送钱了")

        r = Redpack.find_by(beaconid: 23)
        # r.qy_pay(7, money=nil)
        # r.send_pay(7,23, 1,nil)

       ret = r.send_pay(7,23,10)
        # ret = r.send_group_redpack(7)
        p "ret = #{ret.to_i}"


        {"result" => 749792}
      end



    end



  end

end
