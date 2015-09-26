require 'httparty'

module Api
  class Rdio
    include HTTParty
    base_uri 'https://api.spotify.com'
    format :json

    class << self
      def search(query={})
      end

      def lookup(query = {})
      end
    end
  end
end
