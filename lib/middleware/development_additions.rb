class DevelopmentAdditions
  def initialize(app)
    @app = (development?) ?  build_extended_app(app) : app
  end

  def call(env)
    @app.call(env)
  end

  private

  def development?
    ENV['RACK_ENV'] == 'development'
  end

  def build_extended_app(app)
    Rack::Builder.new do
      use Rack::ShowExceptions
      map('/flushall') { run ->(_env) { $redis.flushall } }
      run app
    end
  end
end
