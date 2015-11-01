require 'url_identity_resolver/base'

# http://www.apple.com/itunes/affiliates/resources/documentation/linking-to-the-itunes-music-store.html#CleanLinksDeconstructed
# The given store is really important for the lookup, because there are ids that
# are not available in certain countries
#
module UrlIdentityResolver
  class AppleMusic
    include Base

    PRIMARY_ATRIBUTES = /^https?:\/\/itunes.apple.com
      \/(?<country_code>[a-z]{2})
      \/(?<action>artist|album|playlist)
      (?<description>\/.+)?
        \/id(?<id>(pl\.)?\w+)/xi
    SECONDARY_ATTRIBUTES = /i=(?<id>\w+)/i

    def self.short_url_match?(url)
      url =~ /https?:\/\/itun\.es/
    end

    def self.match?(url)
      !!(
        short_url_match?(url) ||
        url =~ /https?:\/\/itunes\.apple\.com/
      )
    end

    def call
      primary_match = url.to_s.match(PRIMARY_ATRIBUTES)
      secondary_match = url.query.to_s.match(SECONDARY_ATTRIBUTES) || {}

      self.id = secondary_match[:id] || primary_match[:id]
      self.kind = secondary_match[:id] ? 'track' : primary_match[:action]
      self.country_code = primary_match[:country_code].downcase

      true
    end
  end
end
