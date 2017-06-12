
# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Load the SCM plugin appropriate to your project:
#
# require "capistrano/scm/hg"
# install_plugin Capistrano::SCM::Hg
# or
# require "capistrano/scm/svn"
# install_plugin Capistrano::SCM::Svn
# or
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
# require "capistrano/rvm"
# require "capistrano/rbenv"
# require "capistrano/chruby"
# require "capistrano/bundler"
# require "capistrano/rails/assets"
# require "capistrano/rails/migrations"
# require "capistrano/passenger"

#cut from deploy.rb
#require "rvm/capistrano"
require 'capistrano/rvm'
require 'capistrano/rails'
# require 'capistrano/bundler'
require 'sidekiq/capistrano'

# require "rvm/capistrano/selector"
# require "rvm/capistrano/gem_install_uninstall"
# require "rvm/capistrano/alias_and_wrapp"

# Bundler bootstrap
#require 'bundler/capistrano'
require 'capistrano3-unicorn'
require 'capistrano/ext/multistage'
#require 'slack-notifier'
require 'slackistrano/capistrano'


require 'whenever/capistrano'
#cut till here


# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }


=begin
load 'deploy'
# Uncomment if you are using Rails' asset pipeline
    # load 'deploy/assets'
load 'config/deploy' # remove this line to skip loading any of the default tasks
=end