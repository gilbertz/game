require 'digest'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:weixin]

  cattr_accessor :current_user 
  attr_accessor :password
 
  validates :name,                                                                                  
    :presence     => true,
    :on => :create
  #:format       => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }

  validates :password,
  :presence     => true,                                                                   
  :confirmation => true,
  :length       => {in: 6..18},
  :on => :create

  has_many :authentications
  has_many :materials
  has_many :ibeacons
  has_many :checks

  before_create :make_password

  Role = {
      :user => 0,
      :admin => 1
  }

  def self.auth(name, pwd)
    user = self.find_by_name(name.to_s)                                                         
    return user if user && user.authenticate?(pwd)
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
