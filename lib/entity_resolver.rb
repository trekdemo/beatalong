require 'url_matcher/apple_music'
require 'url_matcher/deezer'
# require 'url_matcher/rdio'
require 'url_matcher/spotify'
require 'url_identity_resolver/null'
require 'url_identity_resolver/apple_music'
require 'url_identity_resolver/deezer'
require 'url_identity_resolver/spotify'
# require 'url_identity_resolver/rdio'

class EntityResolver
  RESOLVERS = [
    UrlMatcher::AppleMusic,
    UrlMatcher::Deezer,
    # UrlMatcher::Rdio,
    UrlMatcher::Spotify,
  ]

  attr_reader :url

  def initialize(url)
    @url = url
  end

  def identity
    identity_resolver.identity
  end

  private

  def identity_resolver
    resolver_name = provider_name || 'Null'
    resolver_class = Object.const_get("UrlIdentityResolver::#{resolver_name}")
    resolver_class.new(url)
  end

  def provider_name
    RESOLVERS
      .find { |matcher| matcher.match?(url) }
      .to_s
      .split('::')
      .last
  end
end
