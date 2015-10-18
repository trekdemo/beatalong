source "https://rubygems.org"
ruby '2.2.2'

gem 'rake'
gem 'rack'
gem 'activesupport'
gem 'httparty', require: false
gem 'hiredis'
gem 'redis', require: ['redis', 'redis/connection/hiredis']
gem 'rack-timeout'

group :production do
  gem 'puma'
  gem 'rollbar', '~> 2.2.1'
  gem 'newrelic_rpm'
  gem 'rack-tracker'
end

group :development, :test do
  gem 'pry'
end

group :development do
  gem 'shotgun'
  gem 'derailed'
end

group :test do
  gem 'rspec'
  gem 'vcr'
  gem 'webmock'
  gem 'rack-test'
end
