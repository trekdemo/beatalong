require 'httparty'
require 'provider_entity'

module Api
  class Deezer
    include HTTParty
    base_uri 'http://api.deezer.com'
    format :json

    class << self
      def search(query={})
        fields = query.map {|(k, v)| [k, v.to_s.inspect].join(':') }.join(' ')

        get("/search", query: {q: fields, strict: 'on'})["data"].map do |result|
          ProviderEntity.new({
            artist: result['artist']['name'],
            album: result['album']['title'],
            title: result['title'],
            cover_image_url: result['album']['cover'],
          })
        end
      end

      def lookup(query={})
        get("/lookup", query: query)["results"]
      end

      def find(id)
        lookup(id: id).first
      end
    end
  end
end
