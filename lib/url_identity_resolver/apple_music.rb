require 'url_identity_resolver/base'

module UrlIdentityResolver
  class AppleMusic

    include Base

    def call
      if direct_id = @url.query.to_s.scan(/i=(\d+)/).flatten.first
        self.id = direct_id
      else
        resp = HTTParty.head(@url.to_s, folow_redirects: true)
        apple_url = resp.headers['x-apple-translated-wo-url'].to_s
        self.id = apple_url.scan(/id=(\d+)/).flatten.first
      end
      true
    end

  end
end
