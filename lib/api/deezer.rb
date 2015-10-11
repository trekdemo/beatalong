require 'httparty'
require 'provider_entity'
require 'active_support/core_ext/hash/slice'

module Api
  class Deezer
    include HTTParty
    base_uri 'http://api.deezer.com'
    format :json

    def initialize(*); end

    def find(identity)
      response = get(['/', identity.kind, identity.id].join('/'))
      format_result(response)
    end

    # http://developers.deezer.com/api/search
    def search(entity)
      get(['/search', entity.kind].join('/'), {
        q: search_term(entity),
        strict: 'on',
        limit: 1, # TODO Does it work?
      })["data"]
        .map(&method(:format_result))
        .first
    end

    private

    def get(path, query = nil)
      self.class.get(path, query: query)
    end

    def search_term(entity)
      entity
        .to_h
        .slice(:artist, :album, :track)
        .reject { |_, v| v.nil? }
        .map {|(k, v)| [k, v.to_s.inspect].join(':') }.join(' ')
    end

    def format_result(json)
      send("format_#{json['type']}_result", json)
    end

    def format_artist_result(json)
      ProviderEntity.new({
        artist: json['name'],
        cover_image_url: json['picture_big'],
        url: json['link'],
        kind: 'artist',
      })
    end

    def format_album_result(json)
      ProviderEntity.new({
        artist: json['artist']['name'],
        album: json['title'],
        cover_image_url: json['cover_big'],
        url: json['link'],
        kind: 'album',
      })
    end

    def format_track_result(json)
      ProviderEntity.new({
        artist: json['artist']['name'],
        album: json['album']['title'],
        track: json['title'],
        cover_image_url: json['album']['cover_big'],
        url: json['link'],
        kind: 'track',
      })
    end
  end
end
