#/etc/init.d/redis-server restart
#RAILS_ENV=production bundle exec rake assets:precompile
#rm log/*log -rf
passenger stop --port 7000
passenger start --daemonize --port 7000 -e production
