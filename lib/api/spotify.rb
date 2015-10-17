require 'api/base'
require 'active_support/core_ext/string/inflections'

# https://developer.spotify.com/web-api/search-item/
#
# q        Required. The search query's keywords (and optional field filters and
#          operators)
# type     Required. A comma-separated list of item types to search across.
#          Valid types are: album, artist, playlist, and track.
# limit    Optional. The maximum number of results to return. Default: 20.
#          Minimum: 1. Maximum: 50.
module Api
  class Spotify
    include ::Api::Base
    base_uri 'https://api.spotify.com'

    def find(identity)
      response = get(['/v1', identity.kind.pluralize, identity.id].join('/'))
      format_result(response)
    end

    def search(entity)
      response = get('/v1/search', {
        type: entity.kind,
        q: search_term(entity),
        limit: 1,
      })
      response[entity.kind.pluralize]['items']
        .map(&method(:format_result))
        .first
    end

    private

    def get(path, query = nil)
      self.class.get(path, query: query)
    end

    def search_term(entity)
      clean_api_query_string(
        entity
          .to_h
          .slice(:artist, :album, :track)
          .reject { |_, v| v.nil? }
          .map {|(k, v)| [k, v.to_s.inspect].join(':') }.join('+')
      )
    end

    def format_result(json)
      send("format_#{json['type']}_result", json)
    end

    def format_artist_result(json)
      ProviderEntity.new({
        artist: json['name'],
        cover_image_url: json['images'].first['url'],
        url: json['external_urls']['spotify'],
        kind: json['type'],
      })
    end

    def format_album_result(json)
      ProviderEntity.new({
        artist: json['artists'].to_a.map { |artist| artist['name'] }.join(' - '),
        album: json['name'],
        cover_image_url: json['images'].to_a.map { |img| img['url'] }.first,
        url: json['external_urls']['spotify'],
        kind: json['type'],
      })
    end

    def format_track_result(json)
      ProviderEntity.new({
        artist: json['artists'].first['name'],
        album: json['album']['name'],
        track: json['name'],
        cover_image_url: json['album']['images'].first['url'],
        url: json['external_urls']['spotify'],
        kind: json['type'],
      })
    end
  end
end
