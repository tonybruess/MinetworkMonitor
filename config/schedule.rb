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
job_type :rake, "sleep :sleep && cd :path && RAILS_ENV=:environment bundle exec spring rake :task --silent >/dev/null 2>&1"

every 1.minute do
	rake "update_stathat_data", :sleep => 0

	rake "query_servers", :sleep => 0
	rake "query_servers", :sleep => 10
	rake "query_servers", :sleep => 20
	rake "query_servers", :sleep => 30
	rake "query_servers", :sleep => 40
	rake "query_servers", :sleep => 50
end
