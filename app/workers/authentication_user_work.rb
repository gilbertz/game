class AuthenticationUserWork

  include Sidekiq::Worker

  def perform(authentication_appid,component_appid)

    p "xxxxx========"

  end

end