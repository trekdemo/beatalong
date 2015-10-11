require 'api/apple_music'
require 'api/deezer'
require 'api/spotify'
require 'api/rdio'

require 'erb'

class RedirectApp
  def self.call(env)
    orig_url = env['streamflow.incoming_url'].to_s
    identity = env['streamflow.provider_identity']
    destination_prov_name  = destination_provider(env)
    redirect_to = if identity.provider != destination_prov_name
                    destination_provider_url(identity, destination_prov_name) { env['HTTP_REFERER'] }
                  else
                    orig_url
                  end

    [301, {'Location' => redirect_to}, []]
  end

  def self.destination_provider(env)
    camelize(env['PATH_INFO'].split('/').last.to_s)
  end

  def self.destination_provider_url(identity, destination_prov_name, &blk)
    # Get information based on url
    api_adapter = Object.const_get("Api::#{identity.provider}").new
    entity_data = api_adapter.find(identity)

    # Find entity on destination
    # TODO Detect country_code
    destination_prov_class = Object.const_get("Api::#{destination_prov_name}").new('us')
    destination_provider_data = destination_prov_class.search(entity_data)

    if destination_provider_data
      destination_provider_data.url
    else
      blk.call # fallback
    end
  end

  def self.camelize(term, uppercase_first_letter = true)
      string = term.to_s
      if uppercase_first_letter
        string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      else
        string = string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { $&.downcase }
      end
      string.gsub!(/(?:_|(\/))([a-z\d]*)/) { "#{$1 || $2.capitalize}" }
      string.gsub!(/\//, '::')
      string
    end
end
