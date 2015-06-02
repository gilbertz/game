# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
set :output, File.join(File.dirname(__FILE__), '..', 'log', 'scheduled_tasks.log')

#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

every 1.day, :at => '14:10' do
  rake "convert:sync_redis"
end

every '59 23 * * * ' do
   rake "cutlog:cut"
end

# every '0 0 27-31 * *' do
#   rake "redpack:generate_redpack"
# end


# Learn more: http://github.com/javan/whenever


# every '8,18,28,38,48,58 * * * *' do
#           rake "redpack:notice_redpack_begin"
# end

every 2.minutes do
  rake "redpack:generate_redpack"
end

# every '9,19,29,39,49,59 * * * *' do
#   rake "redpack:generate_redpack"
# end

#every 1.minute do
 #         rake "redpack:generate_test_redpack"
#end

#every '59 7 * * * ' do
#  rake "redpack:generate_ditui_redpack"
#end
