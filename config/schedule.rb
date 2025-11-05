# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
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

# Learn more: http://github.com/javan/whenever

# # test on development env
# whenever --set environment=development --update-crontab
# # check the time
# crontab -l

# # execute on production env
# whenever --set environment=production --update-crontab
# # check the time
# crontab -l

every 1.day, at: ['8:00 am'] do
  rake 'due_date_reminder[60]'
  rake 'due_date_reminder[30]'
  rake 'due_date_reminder[7]'
end

every 1.day, at: ['8:15 am'] do
  rake 'overdue_reminder'
end
