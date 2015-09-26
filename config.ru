require 'rack/builder'

$: << File.expand_path('../lib', __FILE__)

require 'entity_resolver'
require 'jump_app'
require 'redirect_app'


app = Rack::Builder.new do
  use Rack::CommonLogger
  use Rack::ShowExceptions

  use EntityResolver

  map('/j') { run JumpApp }
  map('/r') { run RedirectApp }
end

run app
