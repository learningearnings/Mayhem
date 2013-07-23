require "application_responder"
require 'socket'

class ApplicationController < ActionController::Base
  layout 'resp_application'

  self.responder = ApplicationResponder
  respond_to :html
  include UrlHelper
  include MessagesHelper

  protect_from_forgery

  before_filter :subdomain_required
  around_filter :track_interaction

  # Users are required to access the application
  # using a subdomain
  def subdomain_required
    return if current_user && current_user.respond_to?(:person) && current_user.person.is_a?(LeAdmin)
    return if current_user && !current_user.respond_to?(:person)
    if current_user && (request.subdomain.empty? || request.subdomain != home_subdomain &&
                        (!(current_user.person.is_a?(SchoolAdmin) && [home_subdomain, 'le'].include?(request.subdomain)))
                        ) && home_host
      token = Devise.friendly_token
      current_user.authentication_token = token
      my_redirect_url = home_host   + "/home/?auth_token=#{token}"

      current_user.save
      sign_out(current_user)
      redirect_to my_redirect_url
    end
  end

  def current_ability
    Ability.new(current_person)
  end

  def after_sign_out_path_for(resource_or_scope)
    '/'
  end

  def ensure_le_admin!
    request.query_parameters[:theme] = 'aa'  # for pagination
    current_user.person.is_a?(LeAdmin)
  end

  def authenticate_le_admin!
    if current_person && !current_person.is_a?(LeAdmin)
      flash[:error] = "You must be an admin to access that."
      redirect_to '/' and return
    else
      authenticate_user!
    end
  end

  def home_subdomain
    if session[:current_school_id]
      s = School.find(session[:current_school_id])
      s.store_subdomain.downcase if s
    else
      ""
    end
  end

  def login_schools_list
    School.includes(:addresses => [:state]).order('schools.name asc').all
  end
  helper_method :login_schools_list

  def school_id_by_subdomain
    School.find_by_store_subdomain(request.subdomain).try(:id)
  end
  helper_method :school_id_by_subdomain

  def home_host
    return request.protocol + request.host_with_port unless current_user.person
    if current_user && current_user.person
      # TODO - figure out a better hostname naming scheme
      subdomain = home_subdomain
      if request.host.match /^#{subdomain}\./
        host = request.protocol + request.host_with_port
      else
        if !request.subdomain.empty?
          host = request.host.gsub /^#{request.subdomain}\./,''
        else
          host = request.host
        end
        subdomain = subdomain + '.' + host

        # If this is a development environment, check to see if the
        # hosts file is setup right

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
            flash[:error] = ("Localhost(s) aren't configured correctly for development - use " + "<a href=\"http://lvh.me:3000\">lvh.me:3000</a>").html_safe
            return nil
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

  # Override this anywhere you need to actually know how to get a current_person
  # - i.e. when logged in :)
  def current_person
    if current_user
      current_user.person
    else
      nil
    end
  end

  def track_interaction
    start_time = Time.now
    interaction = Interaction.new ip_address: request.ip
    if current_person
      interaction.person = current_person
    end
    yield
    end_time = Time.now
    interaction.elapsed_milliseconds = (end_time - start_time) * 1_000
    interaction.page = request.path
    # NOTE: Don't know how to get memory usage in here yet
    interaction.save
  end

  def get_reward_highlights highlight_count = 3
    with_filters_params = params
    with_filters_params[:filters] = session[:filters] || [1]
    searcher = Spree::Config.searcher_class.new(with_filters_params)
    searcher.retrieve_products.order('random()').page(1).per(highlight_count)
  end

  protected
  def _prefixes
    @_prefixes_with_partials ||= super | %w(/public)
  end
end
