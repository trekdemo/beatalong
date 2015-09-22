require 'httparty'
require 'uri'

module UrlIdentityResolver
  class AppleMusic

    def initialize(url)
      @url = url
    end

    def call
      resp = HTTParty.head(@url, folow_redirects: true)
      apple_url = resp.headers['x-apple-translated-wo-url'].to_s
      apple_url.scan(/id=(\d+)/).flatten.first
    end
  end
end
