require 'ip_filter'
require 'ip_filter/controller/geo_ip_lookup'

module IpFilter
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      initializer 'ip_filter.insert_into_action_controller' do
        ActiveSupport.on_load :action_controller do
          IpFilter::Railtie.insert
        end
      end
    end
  end

  class Railtie
    def self.insert
      if defined?(::ActionController::Base)
        ::ActionController::Base.send :include, Controller::GeoIpLookup
      end
    end
  end
end
