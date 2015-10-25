require 'url_identity_resolver/base'

module UrlIdentityResolver
  class Rdio
    include Base

    def self.short_url_match?(url)
      url =~ /https?:\/\/(www\.)?rd\.io/
    end

    def self.match?(url)
      !!(
        short_url_match?(url) ||
        url =~ /https?:\/\/(www\.)?rdio\.com/
      )
    end

    def call
      self.id = url.path
      self.kind = %w(track album artist).find { |k| url.to_s.index(k) }

      true
    end
  end
end
