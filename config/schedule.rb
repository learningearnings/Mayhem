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
  runner "AuctionHandler.new.run!", :output => "/home/deployer/logs/auction_handler.log"
end

every :saturday do
  runner "StudentInterestHandler.new.call"
end

every 1.day, :at => '1am' do
  rake "le:sti_nightly_import", :output => "/home/deployer/logs/sti_nightly_import.log"
end

every '0 9 1 * *' do
  runner "BuckDistributor.new(nil, CreditManager.new, 0).run", :output => "/home/deployer/logs/buck_distributer.log"
end

every :saturday do
  rake "le:award_weekly_automatic_credits", :output => "/home/deployer/logs/award_weekly_automatic_credits.log"
end

every "0 0 1 * *" do
  rake "le:award_monthly_automatic_credits", :output => "/home/deployer/logs/award_monthly_automatic_credits.log"
end

every "0 7 * * 0" do
  rake "le:user_activity_report", :output => "/home/deployer/logs/user_activity_report.log"
end

every "0 7 * * 0" do
  rake "le:teacher_activity_report", :output => "/home/deployer/logs/teacher_activity_report.log"
end
