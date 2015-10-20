require 'url_identity_resolver/null'
require 'url_identity_resolver/apple_music'
require 'url_identity_resolver/deezer'
require 'url_identity_resolver/spotify'
require 'url_identity_resolver/rdio'
# require 'url_identity_resolver/google_play_music'

class EntityResolver
  RESOLVERS = [
    UrlIdentityResolver::AppleMusic,
    UrlIdentityResolver::Deezer,
    # UrlIdentityResolver::GooglePlayMusic,
    UrlIdentityResolver::Rdio,
    UrlIdentityResolver::Spotify,
    UrlIdentityResolver::Null, # This must be the last
  ]

  def self.identity_from(url)
    resolver = RESOLVERS.find { |resolver| resolver.match?(url) }
    raise Beatalong::UrlNotSupported if !resolver
    identity = resolver.new(url).identity
    raise Beatalong::IdentityNotFound unless identity && identity.valid?

    identity
  end
end
