source "https://rubygems.org"
ruby '2.2.2'

gem 'rake'
gem 'rack'
gem 'activesupport'
gem 'httparty', require: false

# gem 'rspotify', require: false
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
end

group :test do
  gem 'rspec'
  gem 'vcr'
  gem 'webmock'
end
