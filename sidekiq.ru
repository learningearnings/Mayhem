require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://127.0.0.1:6379'}

  #database_url = 'postgres://deployer:isotope_bang@192.241.241.213:5432/learning_earnings_staging_11_06'
  #if database_url
  #  ENV['DATABASE_URL'] = "#{database_url}?pool=25"
  #  ActiveRecord::Base.establish_connection
  #end
end

Sidekiq.configure_client do |config|
  config.redis = { :url => 'redis://127.0.0.1:6379' }
end

require 'sidekiq/web'
Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == 'LearningEarnings' && password == 'isotope_bang'
end
run Sidekiq::Web
