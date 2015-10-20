require 'rack/builder'
require 'newrelic_rpm'
require 'rack-flash'
require 'active_support/core_ext/object/blank'

$: << File.expand_path('../lib', __FILE__)

require 'initializers'
require 'middleware/development_additions'
require 'middleware/production_additions'
require 'middleware/entity_resolver_middleware'
require 'middleware/error_handler_middleware'
require 'apps/index_app'
require 'apps/jump_app'
require 'apps/redirect_app'
require 'rdio_token_retriever'
require 'beatalong/errors'

app = Rack::Builder.new do
  use DevelopmentAdditions
  use ProductionAdditions
  use Rack::Session::Pool
  use Rack::Flash, :accessorize => [:notice, :error]
  map('/j') do
    use ErrorHandlerMiddleware
    use EntityResolverMiddleware
    run JumpApp.new
  end

  map('/r') do
    use ErrorHandlerMiddleware
    use EntityResolverMiddleware
    run RedirectApp.new
  end

  map('/')  { run IndexApp.new }

  use Rack::Static,
    urls: ['/assets'],
    root: File.expand_path('../public', __FILE__)
  run -> {}
end

run app
