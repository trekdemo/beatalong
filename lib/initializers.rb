if ENV['RACK_ENV'] == 'production'
  require 'rollbar'

  Rollbar.configure do |config|
    config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
  end
end

require 'logger'
$logger = Logger.new(STDOUT)

require 'redis'
require 'redis/connection/hiredis'
$redis = Redis.new(url: ENV['REDIS_URL'], driver: :hiredis, logger: $logger)
