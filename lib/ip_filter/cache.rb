module IpFilter

  # For now just a simple wrapper class for a Memcache client.
  class Cache

    attr_reader :prefix, :store

    def initialize(store, prefix)
      @store = store
      @prefix = prefix
    end

    # Read from the Cache.
    def [](ip)
      case
        when store.respond_to?(:read)
          store.read key_for(ip)
        when store.respond_to?(:[])
          store[key_for(ip)]
        when store.respond_to?(:get)
          store.get key_for(ip)
      end
    end

    # Write to the Cache.
    def []=(ip, value)
      case
        when store.respond_to?(:write)
          store.write key_for(ip), value
        when store.respond_to?(:[]=)
          store[key_for(ip)] = value
        when store.respond_to?(:set)
          store.set key_for(ip), value
      end
    end

    # Cache key for a given URL.
    def key_for(ip)
      [prefix, ip].join
    end
  end
end