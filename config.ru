# This file is used by Rack-based servers to start the application.
require 'grape/jbuilder'
require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application



use Rack::Config do |env|
  env['api.tilt.root'] = Rails.root.join 'app', 'api','views'
end