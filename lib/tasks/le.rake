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
  task :reload! do
    system('killall -9 --verbose --older-than 20s ruby')
    system('killall -9 --verbose --older-than 20s psql')
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end
end
