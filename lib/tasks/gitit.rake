require 'readline'

namespace :git do
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
end
