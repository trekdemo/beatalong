require 'store'

module Api
  class Cached
    attr_reader :adapter

    def initialize(adapter)
      @adapter = adapter
    end

    def find(identity)
      Store.cache cache_key(identity) do
        adapter.find(identity)
      end
    end

    def search(entity)
      adapter.search(entity)
    end

    private

    def cache_key(identity)
      normalized_id =
        if (orig_id = identity.id.to_s).length > 32 # MD5 hexdigest length
          Digest::MD5.hexdigest(orig_id)
        else
          orig_id.rjust(32, '0')
        end

      [identity.provider.underscore, identity.kind, normalized_id].join(':')
    end
  end
end
