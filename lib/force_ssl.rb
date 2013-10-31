# From: http://stackoverflow.com/questions/3861772/force-ssl-using-ssl-requirement-in-rails-2-app
class ForceSSL
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['HTTPS'] == 'on' || env['HTTP_X_FORWARDED_PROTO'] == 'https'
      @app.call(env)
    else
      req = Rack::Request.new(env)
      [301, { "Location" => req.url.gsub(/^http:/, "https:") }, []]
    end
  end
end
