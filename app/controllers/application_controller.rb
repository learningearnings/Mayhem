require "application_responder"
require 'socket'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery

  before_filter :subdomain_required

  # Users are required to access the application
  # using a subdomain
  def subdomain_required
    if current_user && request.subdomain.empty?
      token = Devise.friendly_token
      current_user.authentication_token = token
      my_redirect_url = home_host + "?auth_token=#{token}"
      current_user.save
      sign_out(current_user)
      redirect_to my_redirect_url
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    '/'
  end


  def ensure_le_admin!
    current_user.person.is_a?(LeAdmin)
  end

  def home_subdomain
      subdomain = current_user.person.schools[0].id.to_s
  end


  def home_host
    return request.protocol + request.host_with_port unless current_user.person
    if current_user.person.schools.count > 0
      # TODO - figure out a better hostname naming scheme
      subdomain = current_user.person.schools[0].id.to_s
      if request.host.match /^#{subdomain}\./
        host = request.protocol + request.host_with_port
      else
        subdomain = subdomain + '.' + request.host
        if Rails.env == 'development'
          match_found = false
          begin
            subdomain_address = Addrinfo.getaddrinfo(subdomain,request.port)
          rescue
            subdomain_address = nil
          end
          original_address =  Addrinfo.getaddrinfo(request.host,request.port)
          if subdomain_address
            subdomain_address.each do |sa|
              original_address.each do |oa|
                if sa.ip_address == oa.ip_address
                  match_found = true
                  break
                end
              end
            end
          end
          if !match_found
            subdomain = request.host
            flash[:error] = "Hosts aren't configured correctly for development"
          end
        end
        host = request.protocol + subdomain
        if request.port && request.port != 80
          host = host +':' + request.port.to_s
        end
      end
    else
      request.protocol + request.host_with_port
    end
  end

end
