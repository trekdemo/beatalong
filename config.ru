require 'rack/builder'
require 'newrelic_rpm'

$: << File.expand_path('../lib', __FILE__)

require 'initializers'
require 'middleware/development_additions'
require 'middleware/production_additions'
require 'middleware/entity_resolver_middleware'
require 'apps/jump_app'
require 'apps/redirect_app'
require 'rdio_token_retriever'

app = Rack::Builder.new do
  use DevelopmentAdditions
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
