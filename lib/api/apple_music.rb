require 'httparty'
require 'provider_entity'

module Api
  # Offical docs:
  #   https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html#searching
  class AppleMusic
    include HTTParty
    base_uri 'https://itunes.apple.com'
    format :json

    AVAILABLE_SEARCH_PARAMS = %i[term country media entity attribute callback
      limit lang version explicit]

    def find(identity)
      get('/lookup', {
        id: identity.id,
        entity: itunes_kind(identity.kind),
        country: identity.country_code,
      })
    end

    def search(entity)
      get('/search', normalize_search_query({
        artist: entity.artist,
        album: entity.album,
        track: entity.title,
        media: 'music',
        entity: entity.kind,
      }))
    end

    private

    def get(path, query)
      response = self.class.get(path, query: query)
      if (error_message = response['errorMessage'])
        fail StandardError, "API error: #{error_message}"
      end

      response["results"]
        .map(&method(:format_result))
        .first
    end

    def normalize_search_query(query)
      query.merge!({limit: 1})
      fail ArgumentError, 'Unknown query param: #{}' if (extra = query - AVAILABLE_SEARCH_PARAMS)

      query.slice(*AVAILABLE_SEARCH_PARAMS)
    end

    def format_result(result)
      ProviderEntity.new({
        artist: result['artistName'],
        album: result['collectionName'],
        title: result['trackName'],
        cover_image_url: result['artworkUrl100'],
        url: result['trackViewUrl'] || result['collectionViewUrl'] || result['artistViewUrl']|| result['artistLinkUrl'],
        kind: internal_kind(result['wrapperType']),
        # original: result,
      })
    end

    def itunes_kind(internal_kind)
      case internal_kind
      when 'artist' then 'musicArtist'
      when 'track' then 'song'
      else internal_kind
      end
    end

    def internal_kind(itunes_kind)
      case itunes_kind
      when 'collection' then 'album'
      else itunes_kind
      end
    end
  end
end
