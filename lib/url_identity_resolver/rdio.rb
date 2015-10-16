require 'url_identity_resolver/base'

module UrlIdentityResolver
  class Rdio
    include Base

    def self.match?(url)
      !!(
        url =~ /https?:\/\/(www\.)?rdio\.com/ ||
        url =~ /https?:\/\/(www\.)?rd\.io/
      )
    end

    def call
      short_match = url.to_s.match(/https?:\/\/rd.io\/x\/(?<id>\w+)/)

      self.id = if short_match
        short_match[:id]
      else
        url.path
      end
      true
    end
  end
end
