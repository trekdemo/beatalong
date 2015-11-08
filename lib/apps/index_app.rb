require 'base_controller'

class IndexApp
  extend BaseController

  def self.call(env)
    if env['PATH_INFO'] == '/'
      shared_keys = $redis.zrange('recent_shares', 0, 14)
      shared_count = $redis.zcard('recent_shares')
      recent_shares = shared_keys.map { |k| Store.get(k) }

      render('index', {
        env: env,
        recent_shares: recent_shares,
        shared_count: shared_count,
      })
    else
      # Instead of calling `not_found`
      redirect_to '/'
    end
  end

end
