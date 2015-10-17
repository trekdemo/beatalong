require 'url_identity_resolver/base'

module UrlIdentityResolver
  class Spotify
    include Base

    def self.match?(url)
      !!(
        url =~ /https?:\/\/play.spotify\.com/ ||
        url =~ /spotify:/
      )
    end

    def call
      url_string = url.to_s
      self.kind, self.id = if url_string =~ /spotify:/
        parts = url_string.split(":")
        [parts[1], parts[2]]
      else
        url.path.to_s.scan(/^\/([a-z]+)\/([a-zA-Z0-9]+)/).flatten
      end

      true
    end
  end
end
