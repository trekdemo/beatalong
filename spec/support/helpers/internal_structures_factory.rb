require 'provider_identity'
require 'provider_entity'

module InternalStructuresFactory
  def build_pi(provider, id, kind, country_code = 'nl')
    ProviderIdentity.new(provider: provider, id: id, kind: kind, country_code: country_code)
  end

  def build_pe(kind, artist, album = nil, track = nil)
    ProviderEntity.new(kind: kind, artist: artist, album: album, track: track)
  end
end
