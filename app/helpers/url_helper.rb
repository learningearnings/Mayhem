# From http://railscasts.com/episodes/221-subdomains-in-rails-3?view=asciicast
module UrlHelper
  def with_subdomain(subdomain)
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    [subdomain, request.domain].join
  end
end
