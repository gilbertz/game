set :user, "ubuntu"
set :password, "shangjieba8"
set :deploy_to, "/data/long/apps/game_dev"

role :app, "203.195.191.203"
role :web, "203.195.191.203"
role :db,  "203.195.191.203", primary: true
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
    run "cd #{current_path} && RAILS_ENV=production bundle exec rake assets:precompile"
    run "cd #{current_path} && RAILS_ENV=production bundle exec rake db:migrate"
    run "cd #{current_path} && passenger stop --port 3009 && passenger start --daemonize --port 3009"
  end
end