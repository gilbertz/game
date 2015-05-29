#/etc/init.d/redis-server restart
#RAILS_ENV=production bundle exec rake assets:precompile
#rm log/*log -rf
passenger stop --port 8000
passenger start --daemonize --port 8000 -e production
