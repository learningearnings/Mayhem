class Mobile::V1::Students::BaseController < Mobile::V1::BaseController
  def authenticate
    user = Spree::User.joins(:person).where('people.type = ?', 'Student').authenticate_with_school_id(params[:username], params[:password], params[:school_id])
    if user
      render json: { auth_token: user.generate_auth_token_with_school_id(params[:school_id]), user: user }
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end
end
