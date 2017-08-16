$redis = Rails.env.production? ? Redis.new(:host => "172.20.0.85", :port => "6379") : Redis.new
