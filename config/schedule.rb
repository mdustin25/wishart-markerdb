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

set :output, { error: '/apps/markerdb/project/shared/log/whenever-error.log',
               standard: '/apps/markerdb/project/shared/log/whenever.log' }


# # Rebuild the BLAST database every 4 days
# every 4.days, at: '12am', roles: [:app] do
#   rake 'seq_search:build_blast_db'
# end

# every :saturday, at: '11pm', roles: [:app] do
#   rake 'bmdb:export:all NEWRELIC_ENABLE=false'
# end