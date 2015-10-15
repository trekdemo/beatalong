require 'url_identity_resolver/base'

module UrlIdentityResolver
  class Deezer
    include Base

    def self.match?(url)
      !!(
        url =~ /^https?:\/\/(www\.)?deezer\.com\/(artist|album|track)/
      )
    end

    def call
      self.kind, self.id = *@url.path.to_s.scan(/^\/([a-z]+)\/(\d+)/).flatten
      true
    end
  end
end
