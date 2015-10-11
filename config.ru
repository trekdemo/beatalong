require 'rack/builder'

$: << File.expand_path('../lib', __FILE__)

require 'entity_resolver_middleware'
require 'jump_app'
require 'redirect_app'

APP_ENV = ENV['RACK_ENV']

if APP_ENV == 'production'
  require 'rollbar'
  Rollbar.configure do |config|
    config.access_token = 'a84d60a5230b46cabe7dba37a3713485' # ENV['ROLLBAR_ACCESS_TOKEN']
  end
end

app = Rack::Builder.new do
  use Rack::CommonLogger
  use Rack::ShowExceptions if APP_ENV == 'development'
  if APP_ENV == 'production'
    require 'rack/tracker'
    use(Rack::Tracker) { handler :google_analytics, { tracker: 'UA-2495676-17' } }
  end

  use EntityResolverMiddleware
  use Rack::Static,
    urls: {"/" => 'index.html'},
    index: 'index.html',
    root: File.expand_path('../public', __FILE__)

  map('/j') { run JumpApp.new }
  map('/r') { run RedirectApp }
end

run app
