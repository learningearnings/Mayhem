class HomeHostFinder
  def host_for(subdomain, request)
    subdomain = subdomain
    request_subdomain = request.subdomain
    # if the subdomain is an expected subdomain, set it to nil
    # so that that subdomain doesn't get replaced...
    if expected_subdomains.include?(request_subdomain)
      request_subdomain = nil
    end
    host = request.host
    if host.match /^#{subdomain}\./
      host = request.protocol + request.host_with_port
    else
      if request_subdomain.present?
        host = host.gsub /^#{request_subdomain}\./,''
      end
      subdomain = subdomain + '.' + host

      host = request.protocol + subdomain
      if request.port && request.port != 80
        host = host +':' + request.port.to_s
      end
      host
    end
  end

  def expected_subdomains
    [
      "beta",
      "rclements"
    ]
  end
end
