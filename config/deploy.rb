set :rvm_ruby_string, :local
set :rvm_autolibs_flag, "read-only"
set :rvm_type, :user
require "rvm/capistrano"
require 'sidekiq/capistrano'
require "rvm/capistrano/selector"
require "rvm/capistrano/gem_install_uninstall"
require "rvm/capistrano/alias_and_wrapp"
# Bundler bootstrap
require 'bundler/capistrano'
require 'capistrano-unicorn'
require 'capistrano/ext/multistage'
require 'slack-notify'

# Setup whenever to work right in staging
set :whenever_command, "bundle exec whenever"
set :whenever_environment, defer { stage }
require 'whenever/capistrano'

before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
before 'deploy:setup', 'rvm:create_gemset'
before 'deploy:setup', 'rvm:create_alias'
before 'deploy:setup', 'rvm:create_wrappers'

set :bundle_dir, ''
set :sidekiq_role, :sidekiq
set :sidekiq_default_hooks, true
set :bundle_flags, '--system --quiet'

set :stages, %w(production demo staging sandbox qa demo)
set :default_stage, "staging"

after 'deploy:start',   'unicorn:start'
# after 'deploy:stop',    'unicorn:stop'
#after 'deploy:restart', 'unicorn:duplicate' # before_fork hook implemented (zero downtime deployments)

# main details
set :application,     "Mayhem"

# unicorn bits
set :unicorn_bin, "unicorn_rails"

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "learning_earnings_prod")]
set :deploy_to, "/home/deployer/apps/#{application}"
set :user, "deployer"
set :use_sudo, false

# repo details
set :scm,             :git
set :repository,      "https://github.com/learningearnings/Mayhem.git"
set :branch,          "develop"

# Slack config
set :slack_token, "LQS1Y3049h0I56StyZ1LKNHS"
set :slack_subdomain, "learn"
set :slack_channel, "#general"
set :slack_application, "Mayhem"
set :slack_emoji, ":bradleybot:"
set :slack_username, "bradleybot"
set :slack_local_user, `git config user.name`.chomp

# tasks
namespace :deploy do
  desc "Sends deployment notification to Slack."
  task :start_notify_slack, :roles => :app do
    ::SlackNotify::Client.new(slack_subdomain, slack_token, {
      channel: slack_channel,
      username: slack_username,
      icon_emoji: slack_emoji
    }).notify("#{slack_local_user} started deploying #{slack_application}'s #{branch} to #{fetch(:stage, 'production')}")
  end

  desc "Symlink shared resources on each release"
  task :symlink_shared, :roles => [:app, :sidekiq] do
    run "ln -s #{shared_path}/log #{latest_release}/log"
    run "ln -s #{shared_path}/system #{latest_release}/public/system"
    run "ln -s #{shared_path}/public/assets #{latest_release}/public/assets"
    run "mkdir #{latest_release}/tmp"
    run "rm -fr #{latest_release}/tmp/cache"
    run "ln -s #{shared_path}/tmp/cache #{latest_release}/tmp/cache"
    run "ln -sf #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
    run "ln -sf #{shared_path}/config/initializers/00_env.rb #{latest_release}/config/initializers"
    run "ln -sf #{shared_path}/config/initializers/setup_mail.rb #{latest_release}/config/initializers"
    run "ln -sf #{shared_path}/config/initializers/sidekiq.rb #{latest_release}/config/initializers"
  end

  desc "Precompile assets"
  task :precompile_assets, :roles => :app do
    #precompile the assets
    run "cd #{latest_release}; bundle exec rake assets:precompile RAILS_ENV=#{rails_env}"
  end

  desc "Restart unicorn"
  task :restart, :roles => :app do
    unicorn.restart
  end

  desc "Sends deployment notification to Slack."
  task :end_notify_slack, :roles => :app do
    ::SlackNotify::Client.new(slack_subdomain, slack_token, {
      channel: slack_channel,
      username: slack_username,
      icon_emoji: slack_emoji
    }).notify("#{slack_local_user} has finished deploying #{slack_application}'s #{branch} to #{fetch(:stage, 'production')}")
  end

  desc "Automatically trust .rvmrc after deploy"
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

before 'deploy:precompile_assets', 'deploy:symlink_shared'
before 'deploy:finalize_update',   'deploy:precompile_assets'
before 'deploy:update_code',       'deploy:start_notify_slack'
after  'deploy',                   'deploy:trust_rvmrc'
after  'deploy:restart',           'deploy:end_notify_slack'
after  'deploy:restart',           'deploy:cleanup'
