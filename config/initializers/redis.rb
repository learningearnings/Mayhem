$redis = Rails.env.production? ? Redis.new(:host => "192.241.241.213", :port => "6379") : Redis.new
