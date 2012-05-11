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
          @code_type ||= Ipfilter::Configuration.ip_code_type.to_sym
        end

        def codes
          Ipfilter::Configuration.ip_codes.call
        end

        def whitelist
          Ipfilter::Configuration.ip_whitelist.call
        end

        def allow_loopback?
          @allow_loopback ||= Ipfilter::Configuration.allow_loopback
        end
      end
   
      module InstanceMethods
        private

        def check_ip_location(block = nil)
          code  = request.location[self.class.code_type]
          ip    = request.ip

          perform_check = self.class.allow_loopback? ? (code != "N/A") : true

          if perform_check
            unless valid_code?(code) || valid_ip?(ip)
              block ? block.call : Ipfilter::Configuration.ip_exception.call
            end
          end
        end

        def valid_code?(code)
          Array.wrap(self.class.codes).include?(code)
        end

        def valid_ip?(ip)
          Array.wrap(self.class.whitelist).include?(ip)
        end
      end
    end
  end
end