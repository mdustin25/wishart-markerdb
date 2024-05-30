raw_config = File.read("#{Rails.root}/config/redis.yml")
REDIS_CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys
ENV['REDIS_URL'] = "#{REDIS_CONFIG[:url]}/#{REDIS_CONFIG[:db]}"