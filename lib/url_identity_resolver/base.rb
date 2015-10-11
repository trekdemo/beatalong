require 'active_support/concern'
require 'httparty'
require 'uri'
require 'provider_identity'

module UrlIdentityResolver
  module Base
    extend ActiveSupport::Concern

    included do
      attr_accessor :id, :kind, :url, :country_code
    end

    def initialize(url)
      @url = URI(url)
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
  end
end
