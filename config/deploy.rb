require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)
ENV["to"] ||= '121'
case ENV["to"]
  when '121'
    set :domain, '121.42.47.121'
    set :user, 'root'
    set :password, 'bNg42mjv'
    set :deploy_to, '/data/www/mina'
    ENV['port'] = '2016'
  when '114'
    set :domain, '114.215.120.243'
    set :user, 'root'
    set :password, '449e1fb5'
    set :deploy_to, '/data/www/mina'
    ENV['port'] = '2016'
end

set :repository, 'https://leapcliff:831022@git.coding.net/leapcliff/ibeacon.git'
set :branch, 'master'

# For system-wide RVM install.
set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log']
set :keep_releases, 5

# Optional settings:
 #  set :user, 'root'    # Username in the server to SSH to.
 #  set :passwd, '111111'
#   set :port, '30000'     # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  #invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  #invoke :'rvm:use[ruby-1.9.3-p125@default]'
  
  invoke :'rvm:use[ruby-2.0.0-p481@global]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml'."]
end


task :passenger => :environment do
  invoke :'passenger_stop'
  invoke :'passenger_start'
end

task :passenger_start => :environment do
  queue "source /etc/profile.d/rvm.sh"
 # queue "cd #{deploy_to}/#{current_path} && rvmsudo /usr/local/rvm/gems/ruby-2.0.0-p481/bin/passenger start -a 0.0.0.0 -p #{ENV['port']} -d -e production --pid-file #{deploy_to}/#{shared_path}/passenger.#{ENV['port']}.pid"
  queue "cd #{deploy_to}/#{current_path} && rvmsudo /usr/local/rvm/gems/ruby-2.0.0-p481/bin/passenger  start -a 0.0.0.0 -p #{ENV['port']} -d -e production --pid-file #{deploy_to}/#{shared_path}/passenger.#{ENV['port']}.pid"
end

task :passenger_stop => :environment do
  queue "source /etc/profile.d/rvm.sh"
  #quene "touch #{deploy_to}/#{current_path}/passenger.#{ENV['port']}.pid"
  #queue "cd #{deploy_to}/#{current_path} && rvmsudo /usr/local/rvm/gems/ruby-2.0.0-p481/bin/passenger stop -p #{ENV['port']} --pid-file #{deploy_to}/#{shared_path}/passenger.#{ENV['port']}.pid"
  quene "touch #{deploy_to}/#{current_path}/passenger.#{ENV['port']}.pid"
  queue "cd #{deploy_to}/#{current_path} && rvmsudo /usr/local/rvm/gems/ruby-2.0.0-p481/bin/passenger  stop -p #{ENV['port']} --pid-file #{deploy_to}/#{shared_path}/passenger.#{ENV['port']}.pid"
end


desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
   # invoke :'deploy:cleanup'
   # invoke :passenger

    to :launch do
  #    invoke :'deploy:cleanup'
      invoke :'passenger'
      invoke :'deploy:cleanup'
      #queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      #queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
    end
  end
end



desc "Rollback to previous verison."
task :rollback => :environment do
  queue %[echo "----> Start to rollback"]
  queue %[if [ $(ls #{deploy_to}/releases | wc -l) -gt 1 ]; then echo "---->Relink to previos release" && unlink #{deploy_to}/current && ln -s #{deploy_to}/releases/"$(ls #{deploy_to}/releases | tail -2 | head -1)" #{deploy_to}/current && echo "Remove old releases" && rm -rf #{deploy_to}/releases/"$(ls #{deploy_to}/releases | tail -1)" && echo "$(ls #{deploy_to}/releases | tail -1)" > #{deploy_to}/last_version && echo "Done. Rollback to v$(cat #{deploy_to}/last_version)" ; else echo "No more release to rollback" ; fi]
  invoke :passenger
end
# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

