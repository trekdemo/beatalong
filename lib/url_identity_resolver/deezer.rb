require 'url_identity_resolver/base'

module UrlIdentityResolver
  class Deezer

    include Base

    def call
      self.kind, self.id = *@url.path.to_s.scan(/^\/([a-z]+)\/(\d+)/).flatten
      true
    end
  end
end
