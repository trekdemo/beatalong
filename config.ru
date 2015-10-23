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

  use Rack::Session::Cookie, {
    key: 'rack.session',
    expire_after: 2592000,
    secret: 'U2FsdGVkX1+NhbDrLMj6oGUzDA77BJCbMzBCqGfdOcGCnIAW5JMnVqI5g5KIWEnS',
  }
  use Rack::Flash, accessorize: [:notice, :error]
  use ErrorHandlerMiddleware

  map('/j') do
    use EntityResolverMiddleware
    run JumpApp.new
  end

  map('/r') do
    use EntityResolverMiddleware
    run RedirectApp.new
  end

  use Rack::Static,
    urls: ['/assets'],
    root: File.expand_path('../public', __FILE__)

  run IndexApp
end

run app
