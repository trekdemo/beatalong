require 'httparty'
require 'uri'

module UrlIdentityResolver
  class AppleMusic

    def initialize(url)
      @url = URI(url)
    end

    def call
      if direct_id = @url.query.to_s.scan(/i=(\d+)/).flatten.first
        direct_id
      else
        resp = HTTParty.head(@url.to_s, folow_redirects: true)
        apple_url = resp.headers['x-apple-translated-wo-url'].to_s
        apple_url.scan(/id=(\d+)/).flatten.first
      end
    end
  end
end
