require 'entity_resolver'

class EntityResolverMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    self.class.resolve_identity(env)

    @app.call(env)
  end

  private

  def self.resolve_identity(env)
    # Get the URL specified by the user
    url = Rack::Request.new(env).params['u'].to_s
    env['beatalong.incoming_url'] = url

    # Try to identify the URL
    identity = EntityResolver.identity_from(url)
    env['beatalong.provider_identity'] = identity
  end
end
