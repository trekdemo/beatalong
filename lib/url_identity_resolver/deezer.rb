require 'url_identity_resolver/base'

module UrlIdentityResolver
  class Deezer

    include Base

    def call
      self.kind = @url.path.to_s.scan(/\/([a-z]+)/).flatten.first
      self.id = @url.path.to_s.scan(/\/(\d+)/).flatten.first
      self
    end
  end
end
