require 'digest'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:weixin]

  cattr_accessor :current_user 
  # attr_accessor :password
 
  # validates :name,                                                                                  
  #   :presence     => true,
  #   :on => :create
  # #:format       => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }

  # validates :password,
  # :presence     => true,                                                                   
  # :confirmation => true,
  # :length       => {in: 6..18},
  # :on => :create

  has_many :authentications
  has_many :materials
  has_many :ibeacons
  has_many :checks
  has_many :scores
  has_many :redpacks
  has_many :images
  has_many :user_scores
  has_many :merchants

  # before_create :make_password

  Role = {
      :user => 0,
      :admin => 1
  }

  def self.auth(name, pwd)
    user = self.find_by_name(name.to_s)                                                         
    return user if user && user.authenticate?(pwd)
  end

  def self.by_openid(openid)
    au = Authentication.find_by_uid(openid)
    au.user if au 
  end

  def authenticate?(pwd)
    self.encrypt_pwd == generate_encrypt_pwd(pwd)
  end

  def update_rememberme_token
    unless self.rememberme_token.present? 
      self.update_column :rememberme_token, create_rememberme_token
    end 
  end

  def create_rememberme_token
    ::SecureRandom.urlsafe_base64
  end

  def get_openid
    au = Authentication.find_by_user_id(self.id)
    return au.uid  if au
  end

  def get_user_score(beaconid)
    us = UserScore.find_by(:user_id => self.id, :beaconid => beaconid)
    us = UserScore.create(:user_id => self.id, :beaconid => beaconid, :total_score => 0) unless us
    us
  end

  def total_score(beaconid)
    self.get_user_score(beaconid).total_score.to_i
  end


  def update_user_score(beaconid)
    ss = Score.where(:user_id => self.id, :beaconid => beaconid )
    total_score = ss.sum{|s|s.value.to_i if s}
    us = self.get_user_score( beaconid )
    us.total_score = total_score
    us.save
  end

  def my_rs
     
  end

  def incr_social(beaconid, incr=1)
    key = "social_#{self.id}_#{beaconid}"
    value = 0
    value = $redis.get(key) if $redis.get(key) 
    $redis.set(key, value.to_i + incr.to_i)
  end

  def decr_social(beaconid)
    key = "social_#{self.id}_#{beaconid}"
    $redis.decr(key)
  end

  def social_value(beaconid)
    key = "social_#{self.id}_#{beaconid}"
    $redis.get(key).to_i 
  end
 
  def get_record(beaconid, game_id) 
    self.get_records(beaconid, game_id).last
  end
 
  def get_records(beaconid, game_id)
    Record.where(:user_id => self.id, :beaconid=>beaconid, :game_id => game_id).order('created_at desc')
  end

  def get_score(beaconid, game_id)
    self.get_scores(beaconid, game_id).last
  end

  def get_scores(beaconid, game_id)
    Score.where(:user_id => self.id, :beaconid=>beaconid, :game_id => game_id).order('created_at desc')
  end

  def get_beacon_scores(beaconid)
    Score.where(:user_id => self.id, :beaconid=>beaconid).order('created_at desc')
  end
  

  def mark_scores(beaconid, game_id)
    self.get_beacon_scores(beaconid).each do |s|
      s.update(:state => 1)
    end
  end

  def msg_count(beaconid)
    count = self.social_value(beaconid).to_i
    count += 1 if self.total_score(beaconid) > 0
    count
  end

  def checked?(gid, bid)
     Check.find_by(user_id: self.id, beaconid: bid, state:1, game_id: gid)
  end


  #如果是商户则有关联的 pary_id
  def get_party_id
    party = Party.find_by_openid(self.get_openid)
    return party.id  if party
  end

  def party
     Party.find_by_openid(self.get_openid)
  end

  def is_party?
    Party.find_by_openid(self.get_openid)
  end

  def update_records(beaconid)
    rs = Record.where(:from_user_id => self.id, :beaconid => beaconid, :feedback => nil)
    rs.each do |r|
     r.feedback = 1
     r.save
    end
  end

  def resend_redpack(game_id, beaconid)
      t_score = 9500
      t_num = 4
      rs = Record.where(:from_user_id => self.id, :game_id=>game_id, :feedback =>nil).where("score >= #{t_score}").group('user_id')
      if rs.length >= t_num and self.social_value(beaconid) > 0
        beacon = Ibeacon.find beaconid
        rp = beacon.redpacks.last
        ret = rp.send_pay(self.id, beaconid)
        if ret.to_i > 0
          Record.create(:user_id => self.id, :beaconid => beaconid, :game_id => game_id, :score => ret.to_i, :object_type => 'g_redpack',:object_id => rp.id)
          self.decr_social( beaconid )
          self.update_records( beaconid )
        end
      end
  end

  def self.new_user_of_day(day)
    b = [] 
    first_user = User.where("created_at >= ? and created_at <= ? ", day.beginning_of_day,day.end_of_day).first
    if first_user
      first = first_user.id
    end 
    last_user = User.where("created_at >= ? and created_at <= ? ", day.beginning_of_day,day.end_of_day).last
    if last_user
      last = last_user.id
    end
    if first and last
      for i in 0..(last-first-1)
        b << first+i
      end
    end
    return b 
  end



  private
  def make_password
    self.salt = generate_salt
    self.encrypt_pwd = generate_encrypt_pwd(self.password) 
  end

  def generate_salt
    BCrypt::Engine.generate_salt
  end 

  def generate_encrypt_pwd(password)
    BCrypt::Engine.hash_secret(password, self.salt)
  end

end
