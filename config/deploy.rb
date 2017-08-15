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
require 'slack-notifier'

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

set :stages, %w(production demo staging awsproduction awsdemo awsstaging)
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

# Bonus! Colors are pretty!
def red(str)
  "\e[31m#{str}\e[0m"
end

# Figure out the name of the current local branch
def current_git_branch
  branch = `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//, '')
  puts "Deploying branch #{red branch}"
  branch
end

# repo details

set :scm, :git
set :repository, 'git@github.com:learningearnings/Mayhem.git'
set :branch, current_git_branch

# Slack config
set :slack_webhook_url, 'https://hooks.slack.com/services/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'
set :slack_channel, "#learningearnings-dev"
set :current_branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :slack_application, "Mayhem"
set :slack_emoji, ":ghost:"
set :slack_username, "slackbot"
set :slack_local_user, `git config user.name`.chomp

# tasks
namespace :deploy do
  desc "Sends deployment notification to Slack."
  task :start_notify_slack, roles: :app do
    text = "#{slack_local_user} started deploying #{slack_application}'s #{current_branch} to #{fetch(:stage, 'production')}"
    notifier = Slack::Notifier.new slack_webhook_url, channel: slack_channel, username: slack_username
    notifier.post text: text, icon_emoji: slack_emoji
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
    text = "#{slack_local_user} has finished deploying #{slack_application}'s #{current_branch} to #{fetch(:stage, 'production')}"
    notifier = Slack::Notifier.new slack_webhook_url, channel: slack_channel, username: slack_username
    notifier.post text: text, icon_emoji: slack_emoji
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
