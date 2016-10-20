require 'auth_token.rb'

module Mobile
  module V1
    class BaseController < ActionController::Base
      skip_before_filter :authenticate_request
      around_filter :track_interaction
      before_filter :check_mixpanel 
           
  def track_interaction
    start_time = Time.now
    interaction = Interaction.new ip_address: request.ip
    interaction.person = current_person if current_person
    interaction.school_id = session[:current_school_id]
    yield
    end_time = Time.now
    interaction.elapsed_milliseconds = (end_time - start_time) * 1_000
    interaction.page = request.path
    # NOTE: Don't know how to get memory usage in here yet
    interaction.save
  end
  
  def check_mixpanel
    if !session[:mixpanelinit] and current_user
      MixPanelIdentifierWorker.perform_async(current_user.id, mixpanel_options)
      MixPanelTrackerWorker.perform_async(current_user.id, 'User Login', mixpanel_options)
      session[:mixpanelinit] = true

    end
  end
  
  def mixpanel_options
    if current_user and current_school
      district = District.where(guid: current_school.district_guid).last if current_school.district_guid
      if district
        district_name = (district.name.blank? ? "None" : district.name ) 
      else  
        district_name = "None"
      end
      @options = {:env => Rails.env, 
                  '$email' => current_user.email, 
                  '$username' => current_user.username, 
                  '$first_name' => current_user.person.first_name, 
                  '$last_name' => current_user.person.last_name,
                  :grade => current_user.person.try(:grade),
                  :type => current_user.person.type, :school => current_user.person.school.try(:name),
                  :district_guid => (current_school.district_guid.blank? ? "None" : current_school.district_guid ),
                  :district => district_name,                
                  :credits_scope => current_school.credits_scope, 
                  :school_synced => current_school.synced? }
    else
      @options = {}
    end
    return @options
  end
  
  def log_event
    if current_user
      MixPanelTrackerWorker.perform_async(current_user.id, params[:event], mixpanel_options) 
      render :text => "Logged event #{params[:event]}"
    else
      render :text => "Could not log event, no user"
    end
  end

      def current_user
        if decoded_auth_token
          @current_user ||= Spree::User.find(decoded_auth_token[:user_id])
        else
          @current_user = Person.find(181411).user
        end
      end

      def current_school
        if decoded_auth_token
          @current_school ||= School.find(decoded_auth_token[:school_id])
        else
          @current_school ||= School.find(session[:current_school_id]) if session[:current_school_id]
        end
      end

      def current_person
        @current_person ||= current_user.person
      end

      def schools
        if params[:username] and params[:username].size > 2
          @schools = School.where(id: PersonSchoolLink.where(person_id: Person.with_username(params[:username].downcase).pluck(:id)).pluck(:school_id) ).order(:name)
          if @schools.size == 0
            @schools = School.where(" district_guid is not null and status = 'active' ").order(:name)
          end
        else
          @schools = School.order(:name).status_active
        end
        render json: @schools.map{|x| { id: x.id, name: x.name }}, root: false
      end

      def authenticate_request
        Rails.logger.warn("AKT: Authenticate Request")
        if auth_token_expired?
          Rails.logger.warn("AKT: auth_token_expired")
          fail AuthenticationTimeoutError
        elsif !current_user
          Rails.logger.warn("AKT: !current_user")
          fail NotAuthenticatedError
        end
      end

      def authenticate
        if params[:username].blank?
          render json: { error: 'Please enter a username' }, status: :unauthorized and return
        end
        if params[:password].blank?
          render json: { error: 'Please enter a password' }, status: :unauthorized and return
        end   
        if params[:school_id].blank?
          render json: { error: 'Please select your school' }, status: :unauthorized and return
        end
        user = Spree::User.authenticate_with_school_id(params[:username], params[:password], params[:school_id])

        if user
          render json: { auth_token: user.generate_auth_token_with_school_id(params[:school_id]), user: user }
        else
          #Check for accounts that are not activated
          tuser = Spree::User.where(username: params[:username]).first if params[:username]
          if tuser and tuser.confirmed_at == nil
             render json: { error: 'You must activate your account before logging in.  Please check your email for activation instructions...' }, status: :unauthorized
          else
             render json: { error: 'Invalid username, password or school selection' }, status: :unauthorized
          end
        end
      end

      def decoded_auth_token
        Rails.logger.info("AKT: decoded_auth_token: http_auth_header_content #{http_auth_header_content}")
        Rails.logger.info("AKT: decoded_auth_token: AuthToken.decode #{AuthToken.decode(http_auth_header_content)}")        
        @decoded_auth_token ||= AuthToken.decode(http_auth_header_content)
      end

      def auth_token_expired
        decoded_auth_token && decoded_auth_token.expired?
      end

      def http_auth_header_content
        return @http_auth_header_content if defined? @http_auth_header_content
        @http_auth_header_content = begin
          if request.headers['Authorization'].present?
            request.headers['Authorization'].split(' ').last
          else
            nil
          end
        end
      end
    end
  end
end

class NotAuthenticatedError < StandardError
end

class AuthenticationTimeoutError < StandardError
end
