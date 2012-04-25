require 'ipfilter'

module Ipfilter
  module Request
    def location
      # For now just grab the first value as the best guess.
      @location ||= Ipfilter.search(ip).first
    end
  end
end

if defined?(Rack) and defined?(Rack::Request)
  Rack::Request.send :include, Ipfilter::Request
end
