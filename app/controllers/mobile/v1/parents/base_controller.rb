require 'auth_token.rb'

class Mobile::V1::Parents::BaseController < ActionController::Base
  before_filter :authenticate_request,  :except => [:authenticate, :register] 

  def authenticate
    if params[:username].blank?
      render json: { error: 'Please enter a username' }, status: :unauthorized and return
    end
    
    #Check for accounts that are not activated
    tuser = Spree::User.where(username: params[:username]).first if params[:username]
    if tuser and tuser.confirmed_at == nil
         render json: { error: 'You must activate your account before logging in.  Please check your email for activation instructions...' }, status: :unauthorized and return
    end    
    
    if params[:password].blank?
      render json: { error: 'Please enter a password' }, status: :unauthorized and return
    end   
    # if params[:school_id].blank?
    #   render json: { error: 'Please select your school' }, status: :unauthorized and return
    # end    
      
    user = Spree::User.joins(:person).where('people.type IN (?)', ['Parent']).authenticate_parent(params[:username], params[:password])
    if user
      render json: { auth_token: user.generate_parent_auth_token, user: user }
    else     
      render json: { error: 'Invalid username or password ' }, status: :unauthorized
    end
  end
  
  def register
    if params[:user][:first_name].blank?
      render json: { error: 'Please enter a first name' }, status: :unauthorized and return
    end
    if params[:user][:last_name].blank?
      render json: { error: 'Please enter a last name' }, status: :unauthorized and return
    end
    if params[:user][:username].blank?
      render json: { error: 'Please enter a username' }, status: :unauthorized and return
    end
    if params[:user][:password].blank?
      render json: { error: 'Please enter a password' }, status: :unauthorized and return
    end   
    if params[:user][:email].blank?
      render json: { error: 'Please enter an email address' }, status: :unauthorized and return
    end 
    if params[:user][:relationship].blank?
      render json: { error: 'Please enter a relationship' }, status: :unauthorized and return
    end 
    if params[:user][:phone].blank?
      render json: { error: 'Please enter a Phone Number' }, status: :unauthorized and return
    end 
        
    # See if username is unique
    user = Spree::User.where(username: params[:user][:username].downcase).first
    if user
      render json: { error: 'Username already in use' }, status: :unauthorized and return
    end
    # if School.exists?(['LOWER(name) = LOWER(?) ', params[:user][:name]])
    #   render json: { error: 'School name already in use' }, status: :unauthorized and return
    # end    
    #setup_fake_data
    @parent_signup_form = ParentSignupForm.new(params[:user])
    if @parent_signup_form.save
      #sign_in(@teacher_signup_form.person.user)
      #session[:current_school_id] = @teacher_signup_form.school.id
      UserMailer.delay.teacher_self_signup_email(@parent_signup_form.person)      
      render json: { auth_token: @parent_signup_form.person.user.generate_parent_auth_token, user: @parent_signup_form.person.user }
    else         
      render json: { error: @parent_signup_form.errors.first }, status: :unauthorized
    end    
    
    
  end

  def current_user
    if decoded_auth_token
      @current_user ||= Spree::User.find(decoded_auth_token[:user_id])
    end
  end

  def current_person
    @current_person ||= current_user.person
  end

  def authenticate_request
    #Rails.logger.warn("AKT: Authenticate Request")
    if auth_token_expired?
      render json: { error: "Authentication Time Out Error" }
      #Rails.logger.warn("AKT: auth_token_expired")
      #fail AuthenticationTimeoutError
    elsif !current_user
      #Rails.logger.warn("AKT: !current_user")
      render json: { error: "Not authenticated" }
    end
  end

  def decoded_auth_token
    @decoded_auth_token ||= AuthToken.decode(http_auth_header_content)
  end

  def auth_token_expired?
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

  def setup_fake_data
    params[:user][:city] = "Fake City" if params[:user][:city].blank?
    params[:user][:state_id] = 1 if params[:user][:state_id].blank?
    params[:user][:password_confirmation] = params[:user][:password]
    params[:user][:grade] = 5 
    params[:user][:address1] = "Fake Address"
    params[:user][:zip] = 12345
  end
end

class NotAuthenticatedError < StandardError
end

class AuthenticationTimeoutError < StandardError
end