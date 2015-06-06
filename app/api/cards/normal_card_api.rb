module NORMAL

  module My


    class TextAPI < Grape::API


      version 'v1'

      get '/text_api' do


        {"result" => 749792}
      end



    end



  end

end