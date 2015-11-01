require 'middleware/entity_resolver_middleware'
require 'base_controller'
require 'api/cached'
require 'api/apple_music'
require 'api/deezer'
require 'api/spotify'
require 'api/rdio'

class JumpApp
  include BaseController

  def self.app
    this = self
    Rack::Builder.new do
      use EntityResolverMiddleware
      run this.new
    end
  end

  def call(env)
    provider_identity = env['beatalong.provider_identity']
    entity_data = api_adapter(provider_identity.provider).find(provider_identity)

    template = provider_identity.kind == 'playlist' ? 'jump_pl' : 'jump'

    render(template, {
      request: Rack::Request.new(env),
      provider_identity: provider_identity,
      orig_url: env['beatalong.incoming_url'],
      entity_data: entity_data,
      env: env,
    })
  end

  private

  def api_adapter(provider)
    Api::Cached.new(Object.const_get("Api::#{provider}").new)
  end
end
