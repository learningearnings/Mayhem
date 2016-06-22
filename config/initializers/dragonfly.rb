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
Dragonfly.app.configure do
  # Override the .url method...
  define_url do |app, job, opts|
    thumb = Thumb.find_by_signature(job.signature)
    # If (fetch 'some_uid' then resize to '40x40') has been stored already, give the datastore's remote url ...
    if thumb
      app.datastore.url_for(thumb.uid)
    # ...otherwise give the local Dragonfly server url
    else
      app.server.url_for(job)
    end
  end

  # Before serving from the local Dragonfly server...
  before_serve do |job, env|
    # ...store the thumbnail in the datastore...
    uid = job.store
    # ...keep track of its uid so next time we can serve directly from the datastore
    Thumb.create!(uid: uid, signature: job.signature)
  end

end