$redis = ConnectionPool.new(size: 5, timeout: 5) do
  if ENV["REDISCLOUD_URL"].blank?
    # Use default localhost
    Redis.new
  else
    # Connect to Redis Cloud
    uri = URI.parse(ENV["REDISCLOUD_URL"])
    Redis.new(host: uri.host, port: uri.port, password: uri.password)
  end
end