require 'httparty'

module Api
  class Spotify
    include HTTParty
    base_uri 'https://api.spotify.com'
    format :json

    class << self
      def search(query={})
        fields = query.map {|kv| kv.join(':') }.join(' ').gsub(/\s+/ , '+')
        puts fields
        get("/v1/search", query: {q: fields, type: 'track'})["results"]
      end

      def lookup(query={})
        get("/lookup", query: query)["results"]
      end
    end
  end
end
