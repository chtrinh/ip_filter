# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ipfilter/version"

Gem::Specification.new do |s|
  s.name        = "ipfilter"
  s.version     = Ipfilter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Trinh"]
  s.email       = ["chris@synctv.com"]
  s.date        = Date.today.to_s
  s.summary     = "IP filter solution for Rails."
  s.description = "Filter ip by region/country/continent to grant access. Typically for DRM."
  s.files       = `git ls-files`.split("\n") - %w[ipfilter.gemspec Gemfile init.rb]
  s.require_paths = ["lib"]
end
