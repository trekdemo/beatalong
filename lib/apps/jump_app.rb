require 'middleware/entity_resolver_middleware'
require 'base_controller'
require 'api/cached'
require 'api/apple_music'
require 'api/deezer'
require 'api/spotify'

class JumpApp
  include BaseController

  def self.app
    klass = self
    Rack::Builder.new do
      use EntityResolverMiddleware
      run klass.new
    end
  end

  def call(env)
    provider_identity = env['beatalong.provider_identity']
    entity_data = api_adapter(provider_identity.provider, env['country_code']).find(provider_identity)

    if entity_data
      case provider_identity.kind
      when 'search' then redirect_to("/j?u=#{entity_data.url}")
      else
        template = provider_identity.kind == 'playlist' ? 'jump/playlist' : 'jump/general'
        render(template, {
          request: Rack::Request.new(env),
          provider_identity: provider_identity,
          entity_data: entity_data,
          orig_url: env['beatalong.incoming_url'],
          env: env,
        })
      end
    else
      redirect_to '/', env, error: "We can't find #{provider_identity.id}"
    end
  end

  private

  def api_adapter(provider, country_code)
    Api::Cached.new(Object.const_get("Api::#{provider}").new(country_code))
  end
end
