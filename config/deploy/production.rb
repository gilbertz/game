set :deploy_to, "/var/www/apps/weixin_game"

role :app, "222.73.85.232"
role :web, "222.73.85.232"
role :db,  "222.73.85.232", primary: true
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
    #run "mv #{current_path}/config/database.yml.example #{current_path}/config/database.yml"
    #run "cd #{current_path} && RAILS_ENV=production bundle exec rake assets:precompile"
    #run "touch #{current_path}/tmp/restart.txt"
  end
end
