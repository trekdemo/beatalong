class ErrorHandlerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue Beatalong::UrlNotSupported
    respond_with_error env, "The specified url isn't supported!"
  rescue Beatalong::KindNotSupported => e
    respond_with_error env, "'#{e.unsupported_kind.titleize}' entities are not supported currently! Please share artists, albums or tracks!"
  rescue Beatalong::IdentityNotFound
    respond_with_error env, "No supported entity found on the specified url"
  end

  def respond_with_error(env, message)
    env['x-rack.flash'].error = message
    IndexApp.call(env)
  end
end
