require 'readline'

namespace :git do
  desc "Show the current status of the checkout"
  task :fetch do
    remotes = `git remote`
    remotes.each_line do |l|
      l.strip!
      system "echo git fetch #{l}"
      system "git fetch #{l}"
    end
  end
end
