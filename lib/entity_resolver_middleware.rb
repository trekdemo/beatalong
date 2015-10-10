require 'entity_resolver'

class EntityResolverMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    url = Rack::Request.new(env).params['u'].to_s
    env['streamflow.incoming_url'] = url
    env['streamflow.provider_identity'] = EntityResolver.new(url).identity

    @app.call(env)
  end
end

