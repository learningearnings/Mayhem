$redis = Rails.env.production? ? Redis.new(:host => "127.0.0.1", :port => "6379") : Redis.new

