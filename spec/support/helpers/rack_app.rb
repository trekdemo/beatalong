module RackTestApp
  def app
    @app ||= Rack::Builder.parse_file('config.ru').first
  end
end
