require 'readline'

namespace :le do
  desc "User Activity Report"
  task :user_activity_report => :environment do
    filename = "user_activity_report_#{Time.zone.now.strftime("%m_%d")}.csv"
    File.open("/tmp/" + filename, "w") {|f| f.write Reports::NewUserActivityReport.new.run }
    AdminMailer.user_activity_report(filename).deliver
  end

  desc "Teacher Activity Report"
  task :teacher_activity_report => :environment do
    filename = "teacher_activity_report_#{Time.zone.now.strftime("%m_%d")}.csv"
    File.open("/tmp/" + filename, "w") {|f| f.write Reports::TeacherActivityReport.new.run}
    AdminMailer.teacher_activity_report(filename).deliver
  end

  desc "STI Nightly Import"
  task :sti_nightly_import => :environment do
    StiLinkToken.all.each do |link_token|
      StiImporterWorker.setup_sync(link_token.api_url, link_token.username, link_token.password, link_token.district_guid)
    end
  end

  desc "Build enough codes so there are always 10_000 active codes"
  task :build_otu_codes => :environment do
    number_of_codes_to_make = 100000 - Code.active.count
    puts "Building #{number_of_codes_to_make} codes"
    number_of_codes_to_make.times do
      Code.create
    end
  end
end
