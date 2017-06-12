
# Load DSL and set up stages
require "capistrano/setup"
# Include default deployment tasks
require "capistrano/deploy"
#require "rvm/capistrano"
require 'capistrano/rvm'
require 'capistrano/rails'
# require 'capistrano/bundler'
require 'sidekiq/capistrano'
require 'capistrano3-unicorn'
require 'slackistrano/capistrano'
require 'whenever/capistrano'
# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
