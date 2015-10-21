require 'erb'

class IndexApp
  TEMPLATE_PATH = File.expand_path("../../../views/index.erb", __FILE__)
  TEMPLATE = ERB.new(File.read(TEMPLATE_PATH))

  def self.call(env)
    [200, {'Content-Type' => 'text/html'}, [TEMPLATE.result(binding)]]
  end

end
