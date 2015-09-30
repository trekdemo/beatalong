require 'url_matcher/apple_music'
require 'url_identity_resolver/apple_music'

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
      identity_resolver_class = Object.const_get("UrlIdentityResolver::#{provider_name}")
      identity_resolver       = identity_resolver.new(original_entity_url).call
      provider_id             = identity_resolver.id
      provider_kind           = identity_resolver.kind

      env['streamflow.incoming_url']    = original_entity_url
      env['streamflow.provider_entity'] = [provider_name, provider_id, provider_kind]
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

