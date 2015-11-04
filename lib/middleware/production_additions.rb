class ProductionAdditions
  def initialize(app)
    @app = (production?) ?  build_extended_app(app) : app
  end

  def call(env)
    @app.call(env)
  end

  private

  def production?
    ENV['RACK_ENV'] == 'production'
  end

  def build_extended_app(app)
    require 'rack/tracker'
    require 'rollbar'
    require 'rack-timeout'
    require "rack/timeout/rollbar"

    Rack::Builder.new do
      use Rack::CommonLogger, $logger
      use Rack::ContentLength
      use Rack::Timeout
      Rack::Timeout.timeout = 8
      Rack::Timeout::Logger.level  = Logger::ERROR
      use(Rack::Tracker) { handler :google_analytics, { tracker: 'UA-2495676-17' } }
      run app
    end
  end
end
