#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'capistrano/ext/multistage'
require 'rvm/capistrano'
require 'bundler/capistrano'

#set :bundle_dir, ""
set :stages, %w(staging production)
set :default_stage, "staging"
set :rvm_ruby_string, 'ruby-2.0.0-p247@game'
#set :rvm_type, :system
#set :rvm_bin_path, "/usr/local/rvm/bin"

# main details
set :application, "weixin_game"

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false



# repository
set :scm,         :git
set :repository,  "git@222.73.85.232:weixin_game.git"
set :branch,      'master'
set :keep_releases, 15
set :deploy_via, :remote_cache
set :repository_cache, "cached_copy"
after "deploy", "deploy:cleanup"
