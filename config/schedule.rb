# -*- encoding : utf-8 -*-
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
#


set :output, {:error => 'log/cron_error.log', :standard => '/dev/null'}
job_type :command, "cd :path && RAILS_ENV=:environment :task :output"

every 1.day, :at => '03:33' do
  command 'backup perform -t nm365_backup --config_file config/backup/config.rb --data-path db --log-path log --tmp-path tmp'
end

every 1.day, :at => '05:03' do
   rake "spider:nx28"
end
