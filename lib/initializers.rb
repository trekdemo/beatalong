APP_ROOT = Pathname.new(File.expand_path('../..', __FILE__))

$logger ||= begin
  require 'logger'
  Logger.new(STDOUT)
end

$redis ||= begin
  require 'redis'
  require 'redis/connection/hiredis'
  Redis.new(url: ENV['REDIS_URL'], driver: :hiredis, logger: $logger)
end

if ENV['RACK_ENV'] == 'production'
  require 'rollbar'

  Rollbar.configure do |config|
    config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
  end

  $logger.level = Logger::WARN
end


