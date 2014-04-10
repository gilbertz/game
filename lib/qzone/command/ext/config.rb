# locate the class in lib/qq/command/ext/config.rb
module Qzone::Command::Ext
  module Config
    extend ActiveSupport::Concern

    included do
      cattr_accessor :config
      cattr_accessor :appid, :appkey, :host

      @@config = CONFIG[:qzone]

      %w(appid appkey host).each do |name|
        self.send("#{name}=", config[name])
      end
    end
  end
end