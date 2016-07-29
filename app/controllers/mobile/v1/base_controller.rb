require 'auth_token.rb'

module Mobile
  module V1
    class BaseController < ActionController::Base
      skip_before_filter :authenticate_request

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
