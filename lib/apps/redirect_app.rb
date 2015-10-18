require 'api/apple_music'
require 'api/deezer'
require 'api/spotify'
require 'api/rdio'

require 'erb'

class RedirectApp
  def call(env)
    orig_url = env['beatalong.incoming_url'].to_s
    if (identity = env['beatalong.provider_identity'])
      destination_prov_name  = destination_provider(env)
      redirect_to = if identity.provider != destination_prov_name
                      destination_provider_url(identity, destination_prov_name) { env['HTTP_REFERER'] }
                    else
                      orig_url
                    end

      [301, {'Location' => redirect_to}, []]
    else
      [400, {'Content-Type' => 'text/html'}, ["We cannot reccognize the specified url: #{env['beatalong.incoming_url'].inspect}"]]
    end
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
