require 'action_controller'
require 'ip_filter'
require 'ip_filter/controller/geo_ip_lookup'

class IpController < ::ActionController::Base
  include IpFilter::Controller::GeoIpLookup
  
  validate_ip
  skip_validate_ip :only => [:test_action_skip]

  def test_action
    render :text => "Testing test output"
  end

  def test_action_skip
    render :text => "Testing test output"
  end

end
