require 'api/apple_music'
require 'api/deezer'
require 'api/spotify'
require 'api/rdio'

require 'erb'

class RedirectApp
  def self.call(env)
    orig_url = env['streamflow.incoming_url'].to_s
    provider, id, kind = *env['streamflow.provider_entity']

    entity_data = Object.const_get("Api::#{provider}").find(id)
    destination_prov_name  = destination_provider(env)
    destination_prov_class = Object.const_get("Api::#{destination_prov_name}")

    if provider != destination_prov_name
      destination_provider_data = destination_prov_class.search({
        artist: entity_data.artist,
        album: entity_data.album,
        track: entity_data.title,
      }).first

      if destination_provider_data &&
          (target_location = destination_provider_data.url)
        [301, {'Location' => target_location}, []]
      else
        # redirect back
        [301, {'Location' => env['HTTP_REFERER']}, []]
      end
    else
      [301, {'Location' => orig_url}, []]
    end
  end

  def self.destination_provider(env)
    camelize(env['PATH_INFO'].split('/').last.to_s)
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
