module API

  module Image

    class ImageAPI < Grape::API

      version 'v1'
      helpers do 
      end

      #post :images do
      desc "上传图片"
      get :images do

        {"result" => 323}
      end
      #post :images do







    end

  end

end