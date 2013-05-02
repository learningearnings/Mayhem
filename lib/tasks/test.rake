task :test_env do
  ENV['RAILS_ENV'] = 'test'
end

namespace :test do
  desc "Runs the entire test suite."
  task :all => :test_env do
    Rake::Task['test'].invoke
    Rake::Task['spinach'].invoke
  end
end
