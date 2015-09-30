require 'url_identity_resolver/base'

module UrlIdentityResolver
  class Spotify

    include Base

    def call
      self.kind = @url.path.to_s.scan(/\/([a-z]+)/).flatten.first
      self.id = @url.path.to_s.scan(/\/([a-zA-Z0-9]+)/).flatten.last
      true
    end
  end
end
