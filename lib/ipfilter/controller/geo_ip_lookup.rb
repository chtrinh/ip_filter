module Ipfilter 
  module Controller
    module GeoIpLookup
      # Mix below class methods into ActionController.
      def self.included(base)
        base.send :include, InstanceMethods
        base.send :extend, ClassMethods
      end

      module ClassMethods
        def validate_ip(filter_options = {})
          before_filter :check_ip_location, filter_options
        end
   
        def code_type
          @code_type ||= Ipfilter::Configuration.ip_code_type
        end

        def codes
          @codes ||= Ipfilter::Configuration.ip_codes
        end

        def allow_loopback?
          @allow_loopback ||= Ipfilter::Configuration.allow_loopback
        end
      end
   
      module InstanceMethods
        def check_ip_location
          code_to_validate = request.location[self.class.code_type]

          loopback = self.class.allow_loopback? ? (code_to_validate != "N/A") : true

          if loopback && !Array.wrap(self.class.codes).include?(code_to_validate)
            Ipfilter::Configuration.ip_exception.call
          end
        end
      end
    end
  end
end