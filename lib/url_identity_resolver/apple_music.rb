require 'url_identity_resolver/base'

module UrlIdentityResolver
  class AppleMusic

    include Base

    def call
      if direct_id = @url.query.to_s.scan(/i=(\d+)/).flatten.first
        self.id = direct_id
        self.kind = nil # 'track' are we sure?
      else
        resp = HTTParty.head(@url.to_s, folow_redirects: true)
        translated_uri = resp.headers['x-apple-translated-wo-url'].to_s

        self.id = translated_uri.scan(/id=(\d+)/).flatten.first
        self.kind = nil
      end
      true
    end

  end
end
