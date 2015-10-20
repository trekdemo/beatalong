class ErrorHandlerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      status, headers, response = @app.call(env)
    rescue Beatalong::UrlNotSupported
      message = "The specified url isn't supported!"
    rescue Beatalong::KindNotSupported => e
      message = "'#{e.unsupported_kind.titleize}' entities are not supported currently! Please share artists, albums or tracks!"
    rescue Beatalong::IdentityNotFound
      message = "No supported entity found on the specified url"
    end

    if message
      env['x-rack.flash'].error = message
      IndexApp.new.call(env)

      #[301, {'Location' => "/i"}, []]
    else
      [status, headers, response]
    end

  end
end
