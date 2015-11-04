require 'geoip'

class GeocoderMiddleware
  def initialize(app, geoip_path)
    @app = app
    @geoip = GeoIP.new(geoip_path)
  end

  def call(env)
    env['country_code'] = country_code(env)

    @app.call(env)
  end

  private

  def country_code(env)
    ip = Rack::Request.new(env).ip

    @geoip
      .country(ip)
      .country_code2
      .sub('--', 'US')
      .downcase
  end
end
