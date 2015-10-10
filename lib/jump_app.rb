require 'erb'
require 'api/apple_music'
require 'api/deezer'
require 'api/spotify'
# require 'api/rdio'

class JumpApp
  TEMPLATE_PATH = File.expand_path("../../views/jump.erb", __FILE__)

  def initialize
    @template = ERB.new(File.read(TEMPLATE_PATH))
  end

  def call(env)
    provider_identity = env['streamflow.provider_identity']

    respond_with(
      api_adapter(provider_identity.provider).find(provider_identity),
      env['streamflow.incoming_url']
    )
  end

  private

  def respond_with(entity_data, orig_url)
    [200, {'Content-Type' => 'text/html'}, [@template.result(binding)]]
  end

  def api_adapter(provider)
    Object.const_get("Api::#{provider}")
  end
end
