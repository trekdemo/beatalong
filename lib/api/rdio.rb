require 'api/base'

module Api
  class Rdio
    include ::Api::Base

    base_uri 'https://services.rdio.com/api/1/'

    def search(entity)
      params = {
        query: "#{entity.artist} #{entity.album} #{entity.track}",
        types: entity.kind,
        method: 'search',
      }

      response = post(params)
      response.parsed_response["result"]["results"]
        .map{ |r| format_result(r, kind: entity.kind) }
        .first
    end

    def find(identity)
      params = {
        url: identity.id,
        method: 'getObjectFromUrl',
      }

      response = post(params)
      format_result(response.parsed_response["result"], kind: identity.kind)
    end

    def post(params)
      params[:access_token] = RdioTokenRetriever.instance.token

      self.class.post(
        "",
        body: params
      )
    end

    def format_result(result, kind:)
      ProviderEntity.new({
        kind: kind,
        artist: kind == 'artist' ? result['name'] : result['artist'],
        album: kind == 'album' ? result['name'] : result['album'],
        track: kind == 'track' ? result['name'] : nil,
        url: result['shortUrl'],
        cover_image_url: result['dynamicIcon'],
      })
    end

  end
end
