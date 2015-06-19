class Mobile::V1::Teachers::BaseController < Mobile::V1::BaseController
  def authenticate
    Rails.logger.warn("AKT Teachers Mobile authenticate")
    user = Spree::User.joins(:person).where('people.type IN (?)', ['Teacher', 'SchoolAdmin']).authenticate_with_school_id(params[:username], params[:password], params[:school_id])
    if user
      Rails.logger.warn("Mobile authenticate success, user: #{user.inspect}")
      render json: { auth_token: user.generate_auth_token_with_school_id(params[:school_id]), user: user }
    else
      Rails.logger.warn("Mobile authenticate failure, user: #{params.inspect}")      
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end
end
