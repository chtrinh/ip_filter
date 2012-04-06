require 'ipfilter'
require 'ipfilter/controller/geo_ip_lookup'

module Ipfilter
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      initializer 'ipfilter.insert_into_active_controller' do
        ActiveSupport.on_load :active_controller do
          Ipfilter::Railtie.insert
        end
      end
      rake_tasks do
        load "tasks/ipfilter.rake"
      end
    end
  end

  class Railtie
    def self.insert
      if defined?(::ActionController)
        ::ActionController::Base.send :include, Controller::GeoIpLookup      end
    end
  end
end
