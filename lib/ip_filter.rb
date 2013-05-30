require "ip_filter/configuration"
require "ip_filter/cache"
require "ip_filter/request"
require "ip_filter/lookups/geoip"
require "ipaddr"

module IpFilter
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

  # Validates request's ip based on set configurations.
  def validate(request, response_block)
    ip_code_type   = Configuration.ip_code_type.to_sym
    valid_ip_codes = Configuration.ip_codes.call
    ip_code        = request.location[ip_code_type]
    ip             = request.remote_ip
    perform_check  = Configuration.allow_loopback ? (ip_code != "N/A") : true

    if perform_check
      unless Array.wrap(valid_ip_codes).include?(ip_code) || valid_ip?(ip)
        response_block ? response_block.call : Configuration.ip_exception.call
      end
    end
  end

private
  # Retrieve a Lookup object from the store.
  def get_lookup
    @lookups ||= IpFilter::Lookup::Geoip.new
  end

  # Checks if value looks like an IP address.
  #
  # Does not check for actual validity, just the appearance of four
  # dot-delimited numbers.
  def ip_address?(value)
    !!value.to_s.match(/^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})(\/\d{1,2}){0,1}$/)
  end

  # Checks if value is blank.
  def blank_query?(value)
    !!value.to_s.match(/^\s*$/)
  end

  # Go through each IP/IP range and validate IP against it 
  def valid_ip?(ip)
    Array.wrap(Configuration.ip_whitelist.call).any? do |ip_range| 
      IPAddr.new(ip_range).include?(ip)
    end
  end
end

if defined?(Rails)
  require "ip_filter/railtie"
  IpFilter::Railtie.insert
end
