require 'active_support/core_ext/hash/slice'
require 'api/base'

module Api
  # Offical docs:
  #   https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html#searching
  class AppleMusic
    include Base
    base_uri 'https://itunes.apple.com'

    AVAILABLE_SEARCH_PARAMS = %i[term country media entity attribute callback
      limit lang version explicit]

    def find(identity)
      get('/lookup', {
        id: identity.id,
        entity: itunes_kind(identity.kind),
        country: identity.country_code || country_code,
      })
    end

    def search(entity)
      get('/search', normalize_search_query({
        country: country_code,
        media: 'music',
        entity: itunes_kind(entity.kind),
        term: [entity.artist, entity.album, entity.track].compact.join(' - '),
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
      if !(extra = query.keys - AVAILABLE_SEARCH_PARAMS).empty?
        fail ArgumentError, "Unknown query param: #{extra}"
      end

      query.slice(*AVAILABLE_SEARCH_PARAMS)
    end

    def format_result(result)
      ProviderEntity.new({
        kind: internal_kind(result['wrapperType']),
        artist: result['artistName'],
        album: result['collectionName'],
        track: result['trackName'],
        url: result['trackViewUrl'] || result['collectionViewUrl'] || result['artistViewUrl']|| result['artistLinkUrl'],
        cover_image_url: result['artworkUrl100'],
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
