require File.expand_path('../lib/ip_filter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "ip_filter"
  gem.version       = IpFilter::VERSION
  gem.authors       = ["Chris Trinh", "Ihor Ratsyborynskyy"]
  gem.email         = ["chris.chtrinh@gmail.com", "defsan@gmail.com"]
  gem.summary       = "IP filter solution for Rails."
  gem.description   = "Filter ip by region/country/continent to grant access. Typically for DRM."
  gem.homepage      = "https://github.com/chtrinh/ip_filter"
  gem.files         = `git ls-files`.split("\n") - %w[ip_filter.gemspec Gemfile init.rb]
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]
end
