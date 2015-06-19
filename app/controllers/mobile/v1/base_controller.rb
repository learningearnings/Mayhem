require 'auth_token.rb'

module Mobile
  module V1
    class BaseController < ActionController::Base
      skip_before_filter :authenticate_request

      def current_user
        if decoded_auth_token
          @current_user ||= Spree::User.find(decoded_auth_token[:user_id])
        end
      end

      def current_school
        if decoded_auth_token
          @current_school ||= School.find(decoded_auth_token[:school_id])
        end
      end

      def current_person
        @current_person ||= current_user.person
      end

      def schools
        render json: School.order(:name).status_active.map{|x| { id: x.id, name: x.name }}, root: false
      end

      def authenticate_request
        #Rails.logger.warn("AKT: Authenticate Request")
        if auth_token_expired?
          #Rails.logger.warn("AKT: auth_token_expired")
          fail AuthenticationTimeoutError
        elsif !current_user
          #Rails.logger.warn("AKT: !current_user")
          fail NotAuthenticatedError
        end
      end

      def authenticate
        #Rails.logger.warn("AKT Mobile authenticate")
        user = Spree::User.authenticate_with_school_id(params[:username], params[:password], params[:school_id])

        if user
          #Rails.logger.warn("Mobile authenticate success, user: #{user.inspect}")
          render json: { auth_token: user.generate_auth_token_with_school_id(params[:school_id]), user: user }
        else
          #Rails.logger.warn("Mobile authenticate failure, user: #{params.inspect}")
          render json: { error: 'Invalid username or password' }, status: :unauthorized
        end
      end

      def decoded_auth_token
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
