require 'ipfilter'
require 'ipfilter/controller/geo_ip_lookup'

module Ipfilter
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      initializer 'ipfilter.insert_into_action_controller' do
        ActiveSupport.on_load :action_controller do
          Ipfilter::Railtie.insert
        end
      end
    end
  end

  class Railtie
    def self.insert
      if defined?(::ActionController::Metal)
        ::ActionController::Metal.send :include, Controller::GeoIpLookup
      end
    end
  end
end
