#!/bin/bash                                                                                                                                                            

source /usr/local/rvm/scripts/rvm

cd /root/weixin_game

RAILS_ENV=production bundle exec rake hook:auto
