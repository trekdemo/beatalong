require 'url_identity_resolver/base'

module UrlIdentityResolver
  class Rdio
    include Base

    def self.match?(url)
      !!(
        url =~ /https?:\/\/(www\.)?rdio\.com\/artist\/(.+\/album\/(.+\/track\/)?)?/ ||
        url =~ /https?:\/\/(www\.)?rd\.io/
      )
    end

    def call
      self.id = clean_url.path
      %w(track album artist).each do |kind|
        if clean_url.to_s.match(/\/#{kind}\//)
          self.kind = kind
          break
        end
      end

      true
    end

    def clean_url
      url_string = url.to_s
      return url if url_string =~ /\/artist\//

      HTTParty.head(url, follow_redirects: true).request.last_uri
    end
  end
end
