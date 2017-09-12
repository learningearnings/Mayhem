$redis = Rails.env.production? ? Redis.new(:host => "172.20.0.101", :port => "6379") : Redis.new
