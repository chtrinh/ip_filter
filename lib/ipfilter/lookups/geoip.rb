require 'ipfilter/lookups/base'
require 'ipfilter/results/geoip'
require 'geoip'

module Ipfilter::Lookup
  class Geoip < Base

    private 

    def fetch_data(query, reverse = false)
      unless cache && data = cache[query]
        data = geo_ip_lookup.country(query).to_hash
        cache[query] = data if cache
      end
      data
    end

    def geo_ip_lookup
      @geo_ip_lookup ||= GeoIP.new(Ipfilter::Configuration.geo_ip_dat)
    end

    def results(query, reverse = false)
      # don't look up a loopback address, just return the stored result
      return [reserved_result(query)] if loopback_address?(query)
      [fetch_data(query, reverse)]
    end

    def reserved_result(ip)
      {
        :ip              => ip,
        :country_code    => "N/A",
        :country_code2   => "N/A",
        :country_code3   => "N/A",
        :country_name    => "N/A",
        :continent_code  => "N/A"
      }
    end
  end
end
