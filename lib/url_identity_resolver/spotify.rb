require 'url_identity_resolver/base'

module UrlIdentityResolver
  class Spotify
    include Base

    def self.match?(url)
      !!(
        url =~ /https?:\/\/sptfy\.com/ ||
        url =~ /https?:\/\/play.spotify\.com/
      )
    end

    def call
      self.kind, self.id = *url.path.to_s.scan(/^\/([a-z]+)\/([a-zA-Z0-9]+)/).flatten
      true
    end
  end
end
