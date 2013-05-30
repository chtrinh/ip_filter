module IpFilter 
  module Controller
    module GeoIpLookup
      # Mix below class methods into ActionController.
      def self.included(base)
        base.send :include, InstanceMethods
        base.send :extend, ClassMethods
      end

      module ClassMethods
        def validate_ip(filter_options = {}, &block)
          if block 
            before_filter(filter_options) do |controller|
              controller.check_ip_location(block)
            end
          else
            before_filter :check_ip_location, filter_options
          end
        end

        def skip_validate_ip(filter_options = {})
          skip_before_filter(:check_ip_location, filter_options)
        end
      end

      module InstanceMethods
      private
        def check_ip_location(block = nil)
          IpFilter.validate(request, block)
        end
      end
    end 
  end
end