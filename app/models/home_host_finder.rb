class HomeHostFinder
  def host_for(subdomain, request)
    subdomain = subdomain
    host = request.host
    if host.match /^#{subdomain}\./
      host = request.protocol + request.host_with_port
    else
      if request.subdomain.present?
        host = host.gsub /^#{request.subdomain}\./,''
      end
      subdomain = subdomain + '.' + host

      host = request.protocol + subdomain
      if request.port && request.port != 80
        host = host +':' + request.port.to_s
      end
      host
    end
  end
end
