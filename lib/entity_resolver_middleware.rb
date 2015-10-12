require 'entity_resolver'

class EntityResolverMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    # Get the URL specified by the user
    url = Rack::Request.new(env).params['u'].to_s
    env['streamflow.incoming_url'] = url
    env[:logger].log('url_received', url)

    # Try to identify the URL
    identity = EntityResolver.new(url).identity
    if identity && identity.valid?
      env['streamflow.provider_identity'] = identity
      env[:logger].log('url_identified', identity.to_a)
    else
      env[:logger].log('invalid_identity', true)
    end

    @app.call(env)
  end
end
