Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://192.241.241.213:7372/12'}

  database_url = '192.241.241.213'
  if database_url
    ENV['DATABASE_URL'] = "#{database_url}?pool=25"
    ActiveRecord::Base.establish_connection
  end
end
