require 'store'

module Api
  class Cached
    attr_reader :adapter

    def initialize(adapter)
      @adapter = adapter
    end

    def find(identity)
      key = cache_key_for_identity(identity)
      score = 9_999_999_999 - Time.now.to_f

      Store.cache key do
        result = adapter.find(identity)

        $redis.zadd('recent_shares', score, key) if result && identity.kind != 'search'

        result
      end
    end

    def search(entity)
      Store.cache_hash(*cache_key_field_for_entity(entity)) do
        adapter.search(entity)
      end
    end

    private

    def cache_key_for_identity(identity)
      normalized_id =
        if (orig_id = identity.id.to_s).length > 32 # MD5 hexdigest length
          digest(orig_id)
        else
          orig_id.rjust(32, '0')
        end

      [
        'identity',
        identity.provider.underscore,
        identity.kind,
        normalized_id
      ].join(':')
    end

    def cache_key_field_for_entity(entity)
      [
        [
          'entity',
          entity.kind,
          digest([entity.artist, entity.album, entity.track].compact.join('|')),
        ].join(':'),
        [
          adapter.provider_name,
          adapter.country_code,
        ].join(':')
      ]
    end

    def digest(value)
      Digest::MD5.hexdigest(value)
    end
  end
end
