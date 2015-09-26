require 'httparty'

module Api
  class AppleMusic
    include HTTParty
    base_uri 'https://itunes.apple.com'
    format :json

    class << self
      def search(query={})
        get("/search", query: query)["results"]
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
          artist: result['artistName'],
          album: result['collectionName'],
          title: result['trackName'],
          cover_image_url: result['artworkUrl100'],
          url: result['trackViewUrl'] || result['collectionViewUrl'] || result['artistViewUrl'],
          kind: result['wrapperType'],
          # original: result,
        })
      end
    end
  end
end
