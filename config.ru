require 'rack/builder'
require 'rack-json-logs'
require 'newrelic_rpm'

$: << File.expand_path('../lib', __FILE__)

require 'initializers'
require 'development_additions'
require 'production_additions'
require 'entity_resolver_middleware'
require 'jump_app'
require 'redirect_app'

app = Rack::Builder.new do
  use DevelopmentAdditions
  use Rack::JsonLogs, reraise_exceptions: true # instead of use Rack::CommonLogger
  use ProductionAdditions

  use Rack::Static,
    urls: {"/" => 'index.html'},
    index: 'index.html',
    root: File.expand_path('../public', __FILE__)

  use EntityResolverMiddleware
  map('/j') { run JumpApp.new }
  map('/r') { run RedirectApp }
end

run app
