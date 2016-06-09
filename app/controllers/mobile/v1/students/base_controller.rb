class Mobile::V1::Students::BaseController < Mobile::V1::BaseController
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
    user = Spree::User.joins(:person).where('people.type = ?', 'Student').authenticate_with_school_id(params[:username], params[:password], params[:school_id])
    if user
      render json: { auth_token: user.generate_auth_token_with_school_id(params[:school_id]), user: user }
    else
      render json: { error: 'Invalid username, password or school selection' }, status: :unauthorized
    end
  end
  
end
