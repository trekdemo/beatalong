require 'httparty'
require 'provider_entity'

module Api
  class Deezer
    include HTTParty
    base_uri 'http://api.deezer.com'
    format :json

    class << self
      def search(query={})
        fields = query.map {|(k, v)| [k, v.to_s].join(':') }.join(' ')

        get("/search", query: {q: fields, strict: 'on'})["data"]
          .map(&method(:format_result))
      end

      def lookup(query={})
        get("/lookup", query: query)["results"]
          .map(&method(:format_result))
      end

      def find(id)
        lookup(id: id).first
      end

      private

      def format_result(result)
        ProviderEntity.new({
          artist: result['artist']['name'],
          album: result['album']['title'],
          title: result['title'],
          cover_image_url: result['album']['cover'],
          url: result['link'],
          original: result,
        })
      end
    end
  end
end
