/etc/init.d/redis-server restart
rm log/*log -rf
passenger stop --port 7000
passenger start --daemonize --port 7000 -e production
