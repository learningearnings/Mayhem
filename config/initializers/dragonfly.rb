require 'dragonfly/rails/images'
app = Dragonfly[:images]
app.configure do |c|
  c.allow_fetch_file = true
  c.allow_fetch_url = true
end
app.datastore = Dragonfly::DataStorage::S3DataStore.new({
  bucket_name: ENV['LE_S3_BUCKET'],
  access_key_id: ENV['LE_S3_ACCESS_KEY'],
  secret_access_key: ENV['LE_S3_SECRET_ACCESS_KEY'],
  region: 'us-west-2',
  url_scheme: 'https'
})
