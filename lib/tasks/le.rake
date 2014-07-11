require 'readline'

namespace :le do
  desc "Fetch from all your remotes and list the commits fetched"
  task :fetch do
    commits = `git fetch --all 2>&1`
    commits.each_line do |commit|
      commit.strip!
      if commit.match /^([0-9a-f.]*).*-> *(([^\/]*)\/.*)$/
        puts "------> #{$2} <------"
        puts `git log #{$1} --no-merges --pretty=short --abbrev-commit`
      end
    end
  end
  desc "Do a db:drop db:create db:migrate and db:seed"
  task :reload do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end
  desc "Do a killall ruby, killall pgsql then db:drop db:create db:migrate and db:seed"

  task :tags do
    `ctags -e -f tags --exclude=.git --exclude=\'*.log\' -R * `
    `ctags -e -f gems.tags --exclude=.git --exclude=\'*.log\' -R \`bundle show --paths\``
    `ctags -e --etags-include=tags --etags-include=gems.tags`
  end

  task :reload! do
    system('killall -9 --verbose --older-than 20s ruby')
    system('killall -9 --verbose --older-than 20s psql')
    system('rm -rf public/spree/products/*')
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end

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
