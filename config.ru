require 'rack/builder'
require 'json'

$: << File.expand_path('../lib', __FILE__)

require 'url_matcher/apple_music'
require 'url_identity_resolver/apple_music'
require 'api/apple_music'
require 'api/deezer'

class EntityResolver
  RESOLVERS = [
    UrlMatcher::AppleMusic,
  ]

  def initialize(app)
    @app = app
  end

  def call(env)
    original_entity_url = Rack::Request.new(env).params['u'].to_s
    provider_name       = resolve_provider_name(original_entity_url)

    if provider_name
      identity_resolver = Object.const_get("UrlIdentityResolver::#{provider_name}")
      provider_id       = identity_resolver.new(original_entity_url).call

      env['streamflow.provider_entity'] = [provider_name, provider_id]
    end

    @app.call(env)
  end

  private
  def resolve_provider_name(url)
    RESOLVERS.find { |resolver| resolver.new(url).match? }
             .to_s
             .split('::')
             .last
  end
end

app = Rack::Builder.new do
  use Rack::CommonLogger
  use Rack::ShowExceptions
  use Rack::Lint

  use EntityResolver

  map("/crossroads") { run ->(env) {
    provider = env['streamflow.provider_entity'].first
    id       = env['streamflow.provider_entity'].last

    entity_data = Object.const_get("Api::#{provider}").find(id)
    artist = entity_data['artistName'].to_s
    album  = entity_data['collectionName'].to_s
    track  = entity_data['trackName'].to_s
    deezer_data = Api::Deezer.search(artist: artist, album: album, track: track).first

    data = {
      orig: entity_data,
      deezer: deezer_data.to_h,
    }
    [200, {'Content-Type' => 'application/json'}, [data.to_json]]
  } }
  # map("/redirect")   { run Redirect.new }

  map '/' do
    run Proc.new { |env|
      content = env.map {|(k, v)| [k,v.inspect].join(': ') }.join("\n")
      [200, {'Content-Type' => 'text/plain'}, [content]]
    }
  end
end

run app
