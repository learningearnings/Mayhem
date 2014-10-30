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
set :job_template, "export PATH=$PATH:/usr/local/bin/;bash -l -c ':job'"

every :hour do
  runner "AuctionHandler.new.run!"
end

every :saturday do
  runner "StudentInterestHandler.new.call"
end

every 1.day, :at => '1am' do
  rake "le:sti_nightly_import"
end

#TODO Remove once we are receiving the data over the STI API
every 1.day, :at => '6am' do
  rake "update_city_state_after_sync:run"
end
########################################

every 1.day, :at => '12pm' do
  rake "le:build_otu_codes"
end

every '0 9 1 * *' do
  runner "BuckDistributor.new.run"
end
