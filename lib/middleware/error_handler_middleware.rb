require 'base_controller'
require 'beatalong/errors'

class ErrorHandlerMiddleware
  include BaseController

  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue Beatalong::UrlNotSupported
    respond_with_error env, "The specified url isn't supported!"
  rescue Beatalong::KindNotSupported => e
    respond_with_error env, "'#{e.unsupported_kind.titleize}' entities are not supported currently! Please share artists, albums, tracks or playlists!"
  rescue Beatalong::IdentityNotFound
    respond_with_error env, "Not supported entity found on the specified url"
  rescue Beatalong::ShortUrlError => e
    redirect_to env['PATH_INFO'] + "?u=#{e.long_url}"
  end

  def respond_with_error(env, message)
    redirect_to '/', env, error: message
  end
end
