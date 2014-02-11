require "application_responder"
require 'socket'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  include UrlHelper
  include MessagesHelper

  protect_from_forgery

  before_filter :subdomain_required
  around_filter :set_time_zone
  around_filter :track_interaction

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  # Users are required to access the application
  # using a subdomain
  def subdomain_required
    return unless current_user
    return if !current_user.respond_to?(:person)
    return if current_user.person.is_a?(LeAdmin)
    if not_at_home && home_host
      token = Devise.friendly_token
      current_user.authentication_token = token
      Rails.logger.warn "**************************************"
      Rails.logger.warn home_host
      Rails.logger.warn "**************************************"
      my_redirect_url = home_host + "/home/?auth_token=#{token}"

      current_user.save
      sign_out(current_user)
      redirect_to my_redirect_url
    end
  end

  def current_ability
    Ability.new(current_person)
  end

  def current_school
    School.find(session[:current_school_id])
  end

  def after_sign_out_path_for(resource_or_scope)
    '/'
  end

  def ensure_le_admin!
    request.query_parameters[:theme] = 'aa'  # for pagination
    current_user.person.is_a?(LeAdmin)
  end

  def current_url
    url_for()
  end
  helper_method :current_url

  def authenticate_le_admin!
    if current_person && !current_person.is_a?(LeAdmin)
      flash[:error] = "You must be an admin to access that."
      redirect_to '/' and return
    else
      authenticate_user!
    end
  end

  def home_subdomain
    current_school ? current_school.store_subdomain : ''
  end

  def login_schools_list
    School.includes(:state).order('schools.name asc').all
  end
  helper_method :login_schools_list

  def school_id_by_subdomain
    School.find_by_store_subdomain(actual_subdomain).try(:id)
  end

  def last_school_id
    session[:last_school_id]
  end

  def last_school_id_or_by_subdomain
    last_school_id || school_id_by_subdomain
  end
  helper_method :last_school_id_or_by_subdomain

  def home_host
    HomeHostFinder.new.host_for(home_subdomain, request)
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

  def set_time_zone
    old_time_zone = Time.zone
    if browser_timezone.present?
      Time.zone = browser_timezone
      Rails.logger.warn "**************************"
      Rails.logger.warn "Using #{browser_timezone} for this request"
      Rails.logger.warn "**************************"
    end
    yield
  ensure
    Time.zone = old_time_zone
  end

  def browser_timezone
    convert_from_iana_zone_to_rails cookies["browser.timezone"]
  end

  # Rails decided to make its own time zones because duh time isn't hard enough already.
  # There is a mapping constant to convert from IANA
  def convert_from_iana_zone_to_rails iana_zone
    mapping = ActiveSupport::TimeZone::MAPPING.detect {|k, v| v == iana_zone}
    if mapping
      mapping.first
    else
      Time.zone
    end
  end

  def get_reward_highlights highlight_count = 3
    with_filters_params = params
    with_filters_params[:filters] = session[:filters]
    with_filters_params[:searcher_current_person] = current_person
    with_filters_params[:current_school] = current_school
    with_filters_params[:classrooms] = current_person.classrooms.map(&:id)
    searcher = Spree::Search::Filter.new(with_filters_params)
    @products = searcher.retrieve_products
    @products = filter_rewards_by_classroom(@products)
    if @products.present?
      @products.order('random()').page(1).per(highlight_count)
    else 
      @products = []
    end
  end

  def filter_rewards_by_classroom(products)
    unless current_person.is_a?(LeAdmin)
      classrooms = current_person.classrooms.pluck(:id)
      products.reject! do |product|
        # Products that have no classrooms should not be rejected
        next unless product.classrooms.any?
        # If there is an intersection between the products classrooms and my classrooms, don't reject
        (product.classrooms.pluck(:id) & classrooms).any? ? false : true
      end
      # To fix pagination we need an active record relation, not an array
      # Why are you laughing?
      products = Spree::Product.where(:id => products.map(&:id))
    else
      products
    end
  end

  def site_setting
    SiteSetting.last
  end

  protected
  def _prefixes
    @_prefixes_with_partials ||= super | %w(/public)
  end

  def actual_subdomain
    request.subdomain(1).split(".").first
  end
  helper_method :actual_subdomain

  def not_at_home
    return true if actual_subdomain.blank?
    return actual_subdomain != home_subdomain
  end
end
