require 'active_support/concern'
require 'httparty'
require 'uri'
require 'provider_identity'
require 'beatalong/errors'

module UrlIdentityResolver
  module Base
    extend ActiveSupport::Concern

    included do
      attr_accessor :id, :kind, :url, :country_code
    end

    def initialize(url)
      @url = URI(url)
      fail Beatalong::ShortUrlError.new(long_url) if self.class.short_url_match?(url)

      call
    end

    def identity
      ProviderIdentity.new(
        provider: provider_name,
        id: id,
        kind: kind,
        country_code: country_code,
      )
    end

    def provider_name
      self.class.to_s.split('::').last
    end

    def long_url
      HTTParty.head(url, follow_redirects: true).request.last_uri.to_s
    end

    module ClassMethods
      def short_url_match?(_)
        false
      end
    end
  end
end
