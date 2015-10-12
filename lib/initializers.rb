if ENV['RACK_ENV'] == 'production'
  require 'rollbar'

  Rollbar.configure do |config|
    config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
  end
end
