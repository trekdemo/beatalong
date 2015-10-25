require 'erb'
require 'tilt'
require 'tilt/erb'

module BaseController
  def redirect_to(path, env = nil, flash_messages = nil)
    if flash_messages
      flash_messages.each_pair do |k, v|
        env['x-rack.flash'].send("#{k}=", v)
      end
    end
    #
    render_html(
      %Q(Redirecting to <a href="#{path}">#{path}</a>),
      301,
      {"Location" => path },
    )
  end

  def render(view, locals = {}, status = 200)
    render_html(render_template(view, locals), status)
  end

  def not_found(msg = 'Page not found')
    # render_html(msg, 404)
    render('not_found', {}, 404)
  end

  private

  def render_html(body, status = 200, headers = {})
    [status, headers.merge({'Content-Type' => 'text/html'}), [body]]
  end

  def render_template(path, locals = {}, &block)
    Tilt.new(file(path)).render(self, locals, &block)
  end

  def file(path)
    Dir[File.join('views', "#{path}.html.*")].first
  end
end
