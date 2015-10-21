require 'entity_resolver'

class EntityResolverMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    # Get the URL specified by the user
    url = Rack::Request.new(env).params['u'].to_s
    env['beatalong.incoming_url'] = url

    # Try to identify the URL
    identity = EntityResolver.identity_from(url)
    env['beatalong.provider_identity'] = identity

    @app.call(env)
  end
end
