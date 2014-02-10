set :user, "ubuntu"
set :password, "Gv0NDlO2Cw29N9"
set :deploy_to, "/var/www/apps/weixin_game"

role :app, "10.221.84.136"
role :web, "10.221.84.136"
role :db,  "10.221.84.136", primary: true
# tasks
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  task :trust_rvmrc do
    #run "rvm rvmrc trust #{latest_release}"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "mv #{current_path}/config/database.yml.example #{current_path}/config/database.yml"
    #run "mv #{current_path}/config/database.yml.example #{current_path}/config/database.yml"
    #run "cd #{current_path} && RAILS_ENV=production bundle exec rake assets:precompile"
    #run "touch #{current_path}/tmp/restart.txt"
  end
end
