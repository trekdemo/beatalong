require 'csv'
require 'active_support/core_ext/hash/slice'
require 'api/base'

module Api
  # Offical docs:
  #   https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html#searching
  class AppleMusic
    STORE_FRONTS = Hash[
      CSV
        .read(File.expand_path('../../../config/itunes_store_fronts.csv', __FILE__))
        .map { |(country_code, id, _country_name)| [country_code.downcase.strip, id.strip] }
    ]

    include ::Api::Base
    base_uri 'https://itunes.apple.com'

    AVAILABLE_SEARCH_PARAMS = %i[term country media entity attribute callback
      limit lang version explicit]

    def find(identity)
      case identity.kind
      when 'playlist' then lookup_playlist(identity)
      else
        get('/lookup', {
          id: identity.id,
          entity: itunes_kind(identity.kind),
          country: identity.country_code || country_code,
        })
      end
    end

    def search(entity)
      get('/search', normalize_search_query({
        country: country_code,
        media: 'music',
        entity: itunes_kind(entity.kind),
        term: search_term(entity),
      }))
    end

    private

    # curl \
    # -H "X-Apple-Store-Front: 143452-2,32 t:music2" \
    # -H "User-Agent: iTunes/12.3.1 (Macintosh; # OS X 10.11.1) AppleWebKit/601.2.7.2" \
    # "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewPlaylist?id=pl.5e01462edfd74e23b80e38b9982b30d5" > playlist.json
    def lookup_playlist(identity)
      store_front = "#{STORE_FRONTS[identity.country_code]},32 t:music2"
      get(
        'https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewPlaylist',
        {id: identity.id},
        {'X-Apple-Store-Front' => store_front}
      )
    end

    def search_term(entity)
      clean_api_query_string([entity.artist, entity.album, entity.track].compact.join(' - '))
    end

    def get(path, query, headers = {})
      raw_response = self.class.get(path, query: query, headers: headers)
      response = raw_response.parsed_response

      if raw_response.code > 299 || raw_response.code < 200
        fail StandardError, "API error: #{raw_response.inspect}"
      end
      if (error_message = response['errorMessage'])
        fail StandardError, "API error: #{error_message}"
      end

      if !response['results'].nil?
        response['results']
          .map(&method(:build_entity))
          .first
      elsif !response['storePlatformData'].nil?
        build_playlist(response['storePlatformData']['playlist-product']['results'][query[:id]])
      else
        response
      end
    end

    def normalize_search_query(query)
      query.merge!({limit: 1})
      if !(extra = query.keys - AVAILABLE_SEARCH_PARAMS).empty?
        fail ArgumentError, "Unknown query param: #{extra}"
      end

      query.slice(*AVAILABLE_SEARCH_PARAMS)
    end

    def build_entity(result)
      ProviderEntity.new({
        kind: internal_kind(result['wrapperType'] || result['kind']),
        artist: result['artistName'],
        album: result['collectionName'],
        track: result['trackName'] || result['name'],
        url: (
          result['trackViewUrl'] ||
          result['collectionViewUrl'] ||
          result['artistViewUrl']||
          result['artistLinkUrl'] ||
          result['url']
        ),
        cover_image_url: result['artworkUrl100'].to_s.sub('100x100', '420x420'),
      })
    end

    def build_playlist(response)
      ProviderPlaylist.new({
        title: response['nameRaw'],
        author: response['curatorName'],
        cover_image_url: response['artwork']['url'].sub('{w}', '420').sub('{h}', '420').sub('{f}', 'jpg'),
        url: response['url'],
        tracks: response['children'].values.map(&method(:build_entity))
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
      when 'song' then 'track'
      else itunes_kind
      end
    end
  end
end
