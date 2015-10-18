class Store
  class << self
    def cache(key)
      fail ArgumentError, 'block is mandatory' unless block_given?

      get(key) { set(key, yield) }
    end

    def cache_hash(key, field)
      fail ArgumentError, 'block is mandatory' unless block_given?

      get_hash(key, field) { set_hash(key, field, yield) }
    end

    def set(key, value)
      kf = hash_get_key_field(key)
      set_hash(kf[:key], kf[:field], value)
    end

    def set_hash(key, field, value)
      $redis.hset(key, field, dump(value)) if value

      return value
    end

    def get(key)
      kf = hash_get_key_field(key)
      get_hash(kf[:key], kf[:field]) { yield }
    end

    def get_hash(key, field)
      if (cached = $redis.hget(key, field))
        load(cached.to_s)
      elsif block_given?
        yield
      else
        nil
      end
    end

    private

    def load(value)
      Marshal.load(value)
    end

    def dump(value)
      Marshal.dump(value)
    end

    def hash_get_key_field(key)
      prefix, _, suffix = key.rpartition(':')
      if suffix.length > 2
        {key: "#{prefix}:#{suffix[0..-3]}", field: suffix[-2..-1]}
      else
        {key: prefix.concat(':'), field: suffix}
      end
    end
  end
end
