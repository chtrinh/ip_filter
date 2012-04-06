module Ipfilter
  module Lookup
    class Base

      # Query the GeoIP database for a given IP address, and returns information about 
      # the region/country where the IP address is allocated.
      #
      # Takes a search string (eg: "205.128.54.202") for country info
      # Returns an array of <tt>Ipfilter::Result</tt>s.
      def search(query)
        results(query, false).map { |r| result_class.new(r) }
      end

      private 

      # Ipfilter::Result object or nil on timeout or other error.
      def results(query, reverse = false)
        raise NotImplementedError.new
      end

      # Class of the result objects.
      def result_class
        Ipfilter::Result.const_get(self.class.to_s.split(":").last)
      end

      # The working Cache object.
      def cache
        Ipfilter.cache
      end

      # Checks if address is a loopback.
      def loopback_address?(ip)
        !!(ip == "0.0.0.0" or ip.to_s.match(/^127/))
      end
    end
  end
end
