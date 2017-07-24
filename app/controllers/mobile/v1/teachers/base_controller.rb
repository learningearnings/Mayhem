class Mobile::V1::Teachers::BaseController < Mobile::V1::BaseController
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
    if params[:school_id].blank?
      render json: { error: 'Please select your school' }, status: :unauthorized and return
    end    
    

    
    user = Spree::User.joins(:person).where('people.type IN (?)', ['Teacher', 'SchoolAdmin']).authenticate_with_school_id(params[:username], params[:password], params[:school_id])
    if user
      render json: { auth_token: user.generate_auth_token_with_school_id(params[:school_id]), user: user }
      #MixPanelTrackerWorker.perform_async(user.id, 'Mobile Teacher Login', mixpanel_options)
    else     
      render json: { error: 'Invalid username, password or school selection' }, status: :unauthorized
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
    if params[:user][:name].blank?
      render json: { error: 'Please enter a school name' }, status: :unauthorized and return
    end 
    if params[:user][:email].blank?
      render json: { error: 'Please enter an email address' }, status: :unauthorized and return
    end 
        
    # See if username is unique
    user = Spree::User.where(username: params[:user][:username].downcase).first
    if user
      render json: { error: 'Username already in use' }, status: :unauthorized and return
    end
    if School.exists?(['LOWER(name) = LOWER(?) ', params[:user][:name]])
      render json: { error: 'School name already in use' }, status: :unauthorized and return
    end    
    setup_fake_data
    @teacher_signup_form = TeacherSignupForm.new(params[:user])
    if @teacher_signup_form.save
      #sign_in(@teacher_signup_form.person.user)
      #session[:current_school_id] = @teacher_signup_form.school.id
      UserMailer.delay.teacher_self_signup_email(@teacher_signup_form.person)      
      render json: { auth_token: @teacher_signup_form.person.user.generate_auth_token_with_school_id(@teacher_signup_form.school.id), user: @teacher_signup_form.person.user }
    else         
      render json: { error: @teacher_signup_form.errors.first }, status: :unauthorized
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
