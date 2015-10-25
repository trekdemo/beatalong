require 'middleware/entity_resolver_middleware'
require 'base_controller'
require 'api/apple_music'
require 'api/deezer'
require 'api/spotify'
require 'api/rdio'

class RedirectApp
  include BaseController

  def self.app
    this = self
    Rack::Builder.new do
      use EntityResolverMiddleware
      run this.new
    end
  end

  def call(env)
    identity = env['beatalong.provider_identity']
    destination_prov_name  = destination_provider(env)
    path =
      if identity.provider != destination_prov_name
        destination_provider_url(identity, destination_prov_name) {
          env['x-rack.flash'].error = "Song not found on #{destination_prov_name} (>,<)"
          env['HTTP_REFERER']
        }
      else
        env['beatalong.incoming_url'].to_s
      end

    redirect_to(path)
  end

  private

  def destination_provider(env)
    env['PATH_INFO'].split('/').last.to_s.camelize
  end

  def destination_provider_url(identity, destination_prov_name, &blk)
    # Get information based on url
    api_adapter = cached_api_adapter(identity.provider)
    entity_data = api_adapter.find(identity)

    # Find entity on destination
    # TODO Detect country_code
    destination_provider_data =
      cached_api_adapter(destination_prov_name).search(entity_data)

    if destination_provider_data
      destination_provider_data.url
    else
      blk.call # fallback
    end
  end

  def cached_api_adapter(provider)
    Api::Cached.new(Object.const_get("Api::#{provider}").new('us'))
  end
end
