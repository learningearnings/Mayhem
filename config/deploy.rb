# config/deploy.rb 

set :rvm_ruby_string, :local
set :rvm_autolibs_flag, "read-only"
set :rvm_type, :user
require "rvm/capistrano"
require "rvm/capistrano/selector"
require "rvm/capistrano/gem_install_uninstall"
require "rvm/capistrano/alias_and_wrapp"
require "bundler/capistrano"

before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
before 'deploy:setup', 'rvm:create_gemset'
before 'deploy:setup', 'rvm:create_alias'
before 'deploy:setup', 'rvm:create_wrappers'

before "deploy", "deploy:install_bundler"

set :bundle_dir, ''
set :bundle_flags, '--system --quiet'

set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application,     "Mayhem"
set :scm,             :git
set :repository,      "git@github.com:knewter/Mayhem.git"
set :branch,          "origin/develop"
set :migrate_target,  :current
set :ssh_options,     { forward_agent: true }
set :rails_env,       "production"
### set auto_accept so that if we reload, it doesn't halt because of user input
set :auto_accept,      "1"
set :deploy_to,       "/home/deployer/apps/Mayhem"
set :normalize_asset_timestamps, false

set :user,            "deployer"
set :group,           "deployer"
set :use_sudo,        false

set(:latest_release)  { fetch(:current_path) }

namespace :deploy do
  task :install_bundler, :roles => :app do
    run "type -P bundle &>/dev/null || { /home/deployer/.rvm//wrappers/Mayhem/gem install bundler --no-rdoc --no-ri; }"
  end

  desc "Deploy your application"
  task :default do
    update
    restart
  end

  desc "Setup your git-based deployment app"
  task :setup, except: { no_release: true } do
    dirs = [deploy_to, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
    run "git clone #{repository} #{current_path}"
  end

  task :cold do
    update
    migrate
  end

  task :update do
    transaction do
      update_code
    end
  end

  desc "Update the deployed code."
  task :update_code, except: { no_release: true } do
    run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
    finalize_update
  end

  desc "Reload the database (deletes everything!!!)."
  task :reload, except: { no_release: true } do
#    stop if remote_file_exists?('/tmp/unicorn.mayhemstaging.lemirror.com.pid')
    run "cd #{latest_release}; /home/deployer/.rvm//wrappers/Mayhem/rake le:reload RAILS_ENV=#{rails_env}"
    start
  end

  desc "Precompile assets"
  task :precompile_assets do
    #precompile the assets
    run "cd #{latest_release}; /home/deployer/.rvm//wrappers/Mayhem/rake assets:precompile RAILS_ENV=#{rails_env}"
  end

  desc "Update the database (overwritten to avoid symlink)"
  task :migrations do
    transaction do
      update_code
    end
    migrate
    restart
  end

  task :finalize_update, except: { no_release: true } do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

    # mkdir -p is making sure that the directories are there for some SCM's that don't
    # save empty folders
    run <<-CMD
      source /home/deployer/.bashrc &&
      rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids  &&
      mkdir -p #{latest_release}/public &&
      mkdir -p #{latest_release}/tmp &&
      ln -s #{shared_path}/log #{latest_release}/log &&
      ln -s #{shared_path}/system #{latest_release}/public/system &&
      ln -s #{shared_path}/tmp/pids #{latest_release}/tmp/pids &&
      ln -sf #{shared_path}/tmp/cache #{latest_release}/tmp/cache &&
      ln -sf #{shared_path}/config/database.yml #{latest_release}/config/database.yml &&
      ln -sf #{shared_path}/config/initializers/setup_mail.rb #{latest_release}/config/initializers
    CMD

    if fetch(:normalize_asset_timestamps, true)
      stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
      asset_paths = fetch(:public_children, %w(images stylesheets javascripts)).map { |p| "#{latest_release}/public/#{p}" }.join(" ")
      run "find #{asset_paths} -exec touch -t #{stamp} {} ';'; true", env: { "TZ" => "UTC" }
    end
  end

  desc "Zero-downtime restart of Unicorn"
  task :restart, except: { no_release: true } do
    run "kill -s USR2 `cat /tmp/unicorn.mayhemstaging.lemirror.com.pid`"
  end

  desc "Start unicorn"
  task :start, except: { no_release: true } do
    run "cd #{current_path} ; RAILS_ENV=production unicorn_rails -c config/unicorn.rb -D"
  end

  desc "Stop unicorn"
  task :stop, except: { no_release: true } do
    run "kill -s QUIT `cat /tmp/unicorn.mayhemstaging.lemirror.com.pid`"
  end

  namespace :rollback do
    desc "Moves the repo back to the previous version of HEAD"
    task :repo, except: { no_release: true } do
      set :branch, "HEAD@{1}"
      deploy.default
    end

    desc "Rewrite reflog so HEAD@{1} will continue to point to at the next previous release."
    task :cleanup, except: { no_release: true } do
      run "cd #{current_path}; git reflog delete --rewrite HEAD@{1}; git reflog delete --rewrite HEAD@{1}"
    end

    desc "Rolls back to the previously deployed version."
    task :default do
      rollback.repo
      rollback.cleanup
    end
  end
end

#def remote_file_exists?(full_path)
#  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
#end

def run_rake(cmd)
  run "cd #{current_path}; #{rake} #{cmd}"
end

after 'deploy:finalize_update', 'deploy:precompile_assets'

