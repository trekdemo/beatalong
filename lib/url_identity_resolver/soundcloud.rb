require 'url_identity_resolver/base'
require 'active_support/core_ext/object/blank'

module UrlIdentityResolver
  class Soundcloud
    include Base

    def self.match?(url)
      !!(url =~ /https?:\/\/(www\.)?soundcloud\.com/)
    end

    def call
      self.id   = url.to_s
      self.kind = url.path.split("/").reject(&:blank?).count == 1 ? 'artist' : 'track'

      true
    end
  end
end
