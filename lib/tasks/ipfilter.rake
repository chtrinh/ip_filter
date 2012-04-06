namespace :ipfilter do
  desc "Load the ip seed data from FILE into cache"
  task :seed => :environment do
    file_name = ENV['FILE'] || ENV['file']
    raise "Please specify a FILE" unless file_name

    ip_hash = YAML.load_file(file_name)

    cache = Ipfilter.cache
    raise "You don't have a cache store setup" unless cache

    ip_hash.each do |ip_key, value|
      cache[ip_key] = GeoIP::Country.new(
        ip_key.to_s,                # Requested hostname
        ip_key.to_s,                # Ip address as dotted quad
        value["country_code"],      # GeoIP's country code
        value["country_code2"],     # ISO3166-1 alpha-2 code
        value["country_code3"],     # ISO3166-2 alpha-3 code
        value["country_name"],      # Country name, per ISO 3166
        value["continent_code"]     # Continent code.
      )
    end
  end
end