class ErrorHandlerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue Beatalong::UrlNotSupported => e
      message = e.class.name
    rescue Beatalong::KindNotSupported => e
      message = e.class.name
    rescue Beatalong::IdentityNotFound => e
      message = e.class.name
    end

    if message
      [301, {'Location' => "/"}, []]
    end
  end
end

# [301, {'Location' => redirect_to}, []]
# else
#   [400, {'Content-Type' => 'text/html'}, ["We cannot reccognize the specified url: #{env['beatalong.incoming_url'].inspect}"]]
# end
