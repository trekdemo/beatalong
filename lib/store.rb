class Store
  class << self
    def cache(key)
      fail ArgumentError, 'block is mandatory' unless block_given?

      get(key) { set(key, yield) }
    end

    def set(key, value)
      kf = hash_get_key_field(key)
      $redis.hset(kf[:key], kf[:field], Marshal.dump(value))

      return value
    end

    def get(key)
      kf = hash_get_key_field(key)
      if (cached = $redis.hget(kf[:key], kf[:field]))
        Marshal.load(cached.to_s)
      elsif block_given?
        yield
      else
        nil
      end
    end

    private

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
