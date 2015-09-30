require 'active_support/concern'
require 'httparty'
require 'uri'

module UrlIdentityResolver
  module Base
    extend ActiveSupport::Concern

    included do
      attr_accessor :id, :kind
    end

    def initialize(url)
      @url = URI(url)
      call
    end
  end
end