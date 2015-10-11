require 'httparty'
require 'provider_entity'

module Api
  class Deezer
    include HTTParty
    base_uri 'http://api.deezer.com'
    format :json

    def find(identity)
      response = get(['/', identity.kind, identity.id].join('/'))
      format_result(response)
    end

    def search(query={})
      fields = query.map {|(k, v)| [k, v.to_s].join(':') }.join(' ')

      self.class.get("/search", query: {q: fields, strict: 'on'})["data"]
        .map(&method(:format_result))
    end

    private

    def get(path, query = nil)
      self.class.get(path, query: query)
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
        title: json['title'],
        cover_image_url: json['album']['cover_big'],
        url: json['link'],
        kind: 'track',
      })
    end
  end
end
