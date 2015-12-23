require 'url_identity_resolver/unsupported'
require 'url_identity_resolver/apple_music'
require 'url_identity_resolver/deezer'
require 'url_identity_resolver/spotify'
require 'url_identity_resolver/search'
# require 'url_identity_resolver/google_play_music'
require 'beatalong/errors'

class EntityResolver
  RESOLVERS = [
    UrlIdentityResolver::AppleMusic,
    UrlIdentityResolver::Deezer,
    # UrlIdentityResolver::GooglePlayMusic,
    UrlIdentityResolver::Spotify,
    UrlIdentityResolver::Unsupported,
    UrlIdentityResolver::Search,
  ]

  def self.identity_from(url)
    identity =
      RESOLVERS
        .find { |resolver| resolver.match?(url) }
        .new(url)
        .identity

    raise Beatalong::IdentityNotFound unless identity && identity.valid?

    identity
  end
end
