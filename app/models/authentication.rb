# -*- encoding : utf-8 -*-
class Authentication < ActiveRecord::Base
  belongs_to :user
  validates :provider, :uid, presence: true
  
  def self.find_from_hash(hash)
    uid = hash['uid']
    authen=Authentication.where(:uid => uid.to_s).first()
    user=nil
    if(authen)
      user=User.find_by_id(authen.user_id)
      authen.update_attributes({:expires_at=>hash["credentials"]["expires_at"], :access_token=>hash["credentials"]["token"]})
      #post_to_qq(hash["credentials"]["token"],  hash['uid'] )
    end
    user
  end

  def self.find_from_hash_remote(hash)
    uid = hash['uid']
    #authen=Authentication.where(:provider => hash['provider'], :uid => uid.to_s).first()
    authen=nil
    authen=Authentication.where(:uid => uid.to_s).first()
    user=nil
    if(authen)
      #user=User.where(:id=>authen.user_id).first()
      user=User.find_by_id(authen.user_id)
      #authen.update_attributes({:expires_at=>hash["credentials"]["expires_at"], :access_token=>hash["credentials"]["token"]})
    end
    user
  end

  def self.create_from_hash(hash, user)
    uid = hash['uid']
    #uid = hash['info']['name'] if uid.blank?
    a = Authentication.new(:user_id=>user.id, :uid => uid.to_s, :unionid => hash['unionid'],  :provider => hash['provider'], :access_token=>hash["credentials"]["token"], 
      :expires_at=>hash["credentials"]["expires_at"])
    unless a.save
    end
    print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    #if hash['provider']=="weibo"
    #post_to_weibo(hash["credentials"]["token"], hash["credentials"]["expires_at"])
    #else
      #post_to_qq(hash["credentials"]["token"],  hash['uid'] )
    #end
    user
  end

  def self.create_from_hash_remote(hash, user)
    uid = hash['uid']
    #uid = hash['info']['name'] if uid.blank?
    a = Authentication.new(:user_id=>user.id, :uid => uid.to_s, :provider => hash['provider'])
    #user.authentications << a
    #print a.to_json
    unless a.save
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    end
    user
  end

  def self.post_to_weibo(access_token, expires_at)
  end

  def self.qq_add_pic_t(content, image, access_token, uid)
    conn = Faraday.new(:url => 'https://graph.qq.com') do |faraday|
      faraday.request :multipart
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    ret=conn.post '/t/add_pic_t', :content => content, :pic => Faraday::UploadIO.new(image, 'image/jpeg'), :access_token => access_token, :openid => uid, :oauth_consumer_key =>100407222
    ret
  end




  def user_name
    user = User.find_by_id(self.user_id)
    if user
      user.name
    end
  end




end
