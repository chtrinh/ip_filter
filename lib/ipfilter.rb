require "ipfilter/configuration"
require "ipfilter/cache"
require "ipfilter/request"
require "ipfilter/lookups/geoip"

module Ipfilter
  extend self

  # Search for information about an address.
  def search(query)
    if ip_address?(query) && !blank_query?(query)
      get_lookup.search(query)
    else
      raise ArgumentError, "invalid address"
    end
  end

  # The working Cache object, or +nil+ if none configured.
  def cache
    if @cache.nil? && (store = Configuration.cache)
      @cache = Cache.new(store, Configuration.cache_prefix)
    end
    @cache
  end

  private

  # Retrieve a Lookup object from the store.
  def get_lookup
    @lookups ||= Ipfilter::Lookup::Geoip.new
  end

  # Checks if value looks like an IP address.
  #
  # Does not check for actual validity, just the appearance of four
  # dot-delimited numbers.
  def ip_address?(value)
    !!value.to_s.match(/^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/)
  end

  # Checks if value is blank.
  def blank_query?(value)
    !!value.to_s.match(/^\s*$/)
  end
end

if defined?(Rails)
  require "ipfilter/railtie"
  Ipfilter::Railtie.insert
end
