class ProductionAdditions
  def initialize(app)
    @extended_app = if ENV['RACK_ENV'] == 'production'
      build_extended_app(app)
    else
      app
    end
  end

  def call(env)
    @extended_app.call(env)
  end

  private

  def build_extended_app(app)
    require 'rack/tracker'
    require 'rollbar'

    Rack::Builder.new do
      use Rack::ContentLength
      use(Rack::Tracker) { handler :google_analytics, { tracker: 'UA-2495676-17' } }
      run app
    end
  end
end
