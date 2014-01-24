require 'digest'
class User < ActiveRecord::Base

  attr_accessor :password
  validates :name,                                                                                  
    :presence     => true,
    :uniqueness   => true#,
  #:format       => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }

  validates :password,
  :presence     => true,                                                                   
  :confirmation => true,                                                                   
  :length       => {in: 6..18} 

  before_create :make_password

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