require 'httparty'
require 'uri'

module UrlIdentityResolver
  class Deezer

    attr_accessor :id, :kind

    def initialize(url)
      @url = URI(url)
    end

    def call
      self.kind = @url.path.to_s.scan(/\/([a-z]+)/).flatten.first
      self.id = @url.path.to_s.scan(/\/(\d+)/).flatten.first
      true
    end
  end
end
