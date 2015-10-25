require 'rack/builder'
require 'newrelic_rpm'
require 'rack-flash'
require 'active_support/core_ext/object/blank'

$: << File.expand_path('../lib', __FILE__)

require 'initializers'
require 'middleware/development_additions'
require 'middleware/production_additions'
require 'middleware/error_handler_middleware'
require 'apps/index_app'
require 'apps/jump_app'
require 'apps/redirect_app'
require 'rdio_token_retriever'

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

  map('/j') { run JumpApp.app }
  map('/r') { run RedirectApp.app }

  use Rack::Static, urls: ['/assets'], root: 'public'

  run IndexApp
end

run app
