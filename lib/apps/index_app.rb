require 'base_controller'

class IndexApp
  extend BaseController

  def self.call(env)
    if env['PATH_INFO'] == '/'
      render 'index', env: env
    else
      # Instead of calling `not_found`
      redirect_to '/'
    end
  end

end
