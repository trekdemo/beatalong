require 'api/base'
require 'soundcloud'

module Api
  class Soundcloud

    include ::Api::Base

    def search(entity)
      return false unless %w{artist track}.include?(entity.kind)

      endpoint = entity.kind == 'artist' ? '/users' : '/tracks'

      response = client.get(endpoint, q: search_term(entity))
      response.map{|r| format_result(r, kind: entity.kind) }.first
    end

    def find(identity)
      result = client.get('/resolve', :url => identity.id)

      format_result(result, kind: identity.kind)
    end

    private

    def search_term(entity)
      # clean_api_query_string("#{entity.artist} #{entity.track}")
      "#{entity.artist} #{entity.track}"
    end

    def client
      @client ||= ::Soundcloud.new(client_id: ENV['SOUNDCLOUD_CLIENT_ID'])
    end

    def format_result(result, kind:)
      ProviderEntity.new({
        kind: kind,
        artist: kind == 'artist' ? result['username'] : result['user']['username'],
        album: nil,
        track: kind == 'track' ? result['title'] : nil,
        url: result['permalink_url'],
        cover_image_url: kind == 'artist' ? result['avatar_url'] : result['artwork_url'],
      })
    end

  end
end
