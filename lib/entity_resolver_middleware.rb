require 'entity_resolver'

class EntityResolverMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    url = Rack::Request.new(env).params['u'].to_s
    identity = EntityResolver.new(url).identity

    env['streamflow.incoming_url'] = url
    env[:logger].log('url_received', url)

    if identity && identity.valid?
      env['streamflow.provider_identity'] = identity
      env[:logger].log('url_identified', identity.to_a)
    else
      env[:logger].log('invalid_identity', true)
    end

    @app.call(env)
  end
end
