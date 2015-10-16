require 'rack/builder'
require 'newrelic_rpm'

$: << File.expand_path('../lib', __FILE__)

require 'initializers'
require 'development_additions'
require 'production_additions'
require 'entity_resolver_middleware'
require 'jump_app'
require 'redirect_app'
require 'rdio_token_retriever'

app = Rack::Builder.new do
  use DevelopmentAdditions
  use Rack::CommonLogger
  use ProductionAdditions

  use EntityResolverMiddleware
  map('/j') { run JumpApp.new }
  map('/r') { run RedirectApp.new }
  use Rack::Static,
    index: 'index.html',
    urls: ['/', '/assets'],
    root: File.expand_path('../public', __FILE__)
  run -> {}
end

run app
