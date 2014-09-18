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

before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
before 'deploy:setup', 'rvm:create_gemset'
before 'deploy:setup', 'rvm:create_alias'
before 'deploy:setup', 'rvm:create_wrappers'

# Slack notification settings
set :slack_token, '62kjrF5RV1MdkQHy7HhZxHE9'
set :slack_subdomain, 'isotope11'
set :slack_room, '#learningearnings'
set :slack_application, 'Mayhem'
set :slack_emoji, ":james:"
set :slack_username, "jamesbot"

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
set :repository,      "git@github.com:learningearnings/Mayhem.git"
set :branch,          "develop"

# Slack config
set :slack_token, "62kjrF5RV1MdkQHy7HhZxHE9"
set :slack_subdomain, "isotope11"
set :slack_channel, '#learningearnings'
set :slack_application, 'Mayhem'
set :slack_emoji, ":james:"
set :slack_username, "jamesbot"
set :slack_local_user, `git config user.name`.chomp


# tasks
namespace :deploy do
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

  desc "Sends deployment notification to Slack."
  task :notify_slack, :roles => :app do
    ::SlackNotify::Client.new(slack_subdomain, slack_token, {
      channel: slack_channel,
      username: slack_username,
      icon_emoji: slack_emoji
    }).notify("#{slack_local_user} is deploying #{slack_application}'s #{branch} to #{fetch(:stage, 'production')}")
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
end

before 'deploy:precompile_assets', 'deploy:symlink_shared'
before 'deploy:finalize_update', 'deploy:precompile_assets'
before 'deploy', 'deploy:notify_slack'
