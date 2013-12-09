require 'dragonfly/rails/images'
app = Dragonfly[:images]
app.configure do |c|
  c.allow_fetch_file = true
  c.allow_fetch_url = true
end

app.datastore = Dragonfly::DataStorage::S3DataStore.new
app.datastore.configure do |c|
  c.bucket_name = ENV['LE_S3_BUCKET']
  c.access_key_id = ENV['LE_S3_ACCESS_KEY']
  c.secret_access_key = ENV['LE_S3_SECRET_ACCESS_KEY']
  c.region = 'us-west-2'
  c.url_scheme = 'https'
end
