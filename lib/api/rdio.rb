require 'api/base'

module Api
  class Rdio

    class InvalidTokenException < StandardError; end

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

    private

    def post(params)
      response = begin
        params[:access_token] = RdioTokenRetriever.instance.token
        post_request(params)
      rescue InvalidTokenException
        params[:access_token] = RdioTokenRetriever.instance.refresh_token
        post_request(params)
      end

      response
    end

    def post_request(params)
      response = self.class.post("", body: params)

      if response['error'] == 'invalid_token'
        raise InvalidTokenException
      elsif response['error']
        raise StandardError, "API error: #{response['error']} (#{response['error_description']})"
      end
      response
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
