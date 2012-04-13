module Ipfilter 
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
            before_filter filter_options do |controller|
              controller.check_ip_location(block)
            end
          else
            before_filter :check_ip_location, filter_options
          end
        end

        def skip_validate_ip(filter_options = {})
          skip_before_filter(:check_ip_location, filter_options)
        end
   
        def code_type
          @code_type ||= Ipfilter::Configuration.ip_code_type
        end

        def codes
          @codes ||= Array.wrap(Ipfilter::Configuration.ip_codes)
        end

        def whitelist
          @whitelist ||= Array.wrap(Ipfilter::Configuration.ip_whitelist)
        end

        def allow_loopback?
          @allow_loopback ||= Ipfilter::Configuration.allow_loopback
        end
      end
   
      module InstanceMethods
        def check_ip_location(block = nil)
          code_to_validate = request.location[self.class.code_type]

          loopback = self.class.allow_loopback? ? (code_to_validate != "N/A") : true

          if loopback && !Array.wrap(self.class.codes).include?(code_to_validate)
            block ? block.call : Ipfilter::Configuration.ip_exception.call
          end
        end

        def not_valid_ip? 
          code_to_validate = request.location[self.class.code_type]

          loopback = self.class.allow_loopback? ? (code_to_validate != "N/A") : true
          loopback && !self.class.whitelist.include?(request.ip) && self.class.codes.include?(code_to_validate)
        end
      end
    end
  end
end