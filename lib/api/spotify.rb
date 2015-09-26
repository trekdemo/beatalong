require 'httparty'

module Api
  class Spotify
    include HTTParty
    base_uri 'https://api.spotify.com'
    format :json

    class << self
      def search(query={})
        # fields = query.map {|kv| kv.join(':') }.join(' ').gsub(/\s+/ , '+')
        fields = query.values.join(' - ')
        get("/v1/search", query: {q: fields, type: 'track'})['tracks']["items"]
          .map(&method(:format_result))
      end

      def lookup(query={})
        get("/lookup", query: query)["results"]
          .map(&method(:format_result))
      end

      private
      def format_result(result)
        ProviderEntity.new({
          artist: result['artists'].first['name'],
          album: result['album']['name'],
          title: result['name'],
          cover_image_url: result['album']['images'].first['url'],
          url: result['external_urls']['spotify'],
          kind: result['type'],
          # original: result,
        })
      end

    end
  end
end
