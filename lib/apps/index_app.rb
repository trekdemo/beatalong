require 'erb'

class IndexApp
  TEMPLATE_PATH = File.expand_path("../../../views/index.erb", __FILE__)

  def initialize
    @template = ERB.new(File.read(TEMPLATE_PATH))
  end

  def call(env)
    [200, {'Content-Type' => 'text/html'}, [@template.result(binding)]]
  end

end
