Spree::UserSessionsController.class_eval do
  before_filter :set_current_school_id, only: [:destroy]
  after_filter :set_school_id_cookie, only: [:destroy]

  def create
    
    #Check for accounts that are not activated
    tuser = Spree::User.where(username: params[:user]["username"]).first if params[:user]
    if tuser and tuser.confirmed_at == nil
         flash[:error] = "You must activate your account before logging in.  Please check your email for activation instructions..."
         redirect_to main_app.page_path('home')
         return
    end

    authenticate_user!
    session[:last_school_id] = params[:user]["school_id"] if params[:user]
    session[:current_school_id] = params[:user]["school_id"] if params[:user]

    if user_signed_in?
      #MixPanelIdentifierWorker.perform_async(current_user.id, {'email' => current_user.email, 'username' => current_user.username, 'first_name' => current_user.person.first_name, 'last_name' => current_user.person.last_name, 'type' => current_user.person.type, 'school' => current_user.person.school.try(:name)})
      #MixPanelTrackerWorker.perform_async(current_user.id, 'User Login', {'email' => current_user.email, 'username' => current_user.username, 'type' => current_user.person.type, 'school' => current_user.person.school.try(:name)})
      respond_to do |format|
        format.html {
          flash.notice = t(:logged_in_succesfully)
          redirect_to main_app.home_path
        }
        format.js {
          user = resource.record
          render :json => {:ship_address => user.ship_address, :bill_address => user.bill_address}.to_json
        }
      end
    else
      flash[:error] = "Wrong Username, Password and School combination.  Please make sure you have all 3 credentials correct and try again."
      redirect_to main_app.page_path('home')
    end
  end

  def new
    redirect_to main_app.page_path('home')
  end
  private
  def set_current_school_id
    if current_school
      @current_school_id = current_school.id
    else
      @current_school_id = nil
    end
  end

  def set_school_id_cookie
    cookies[:last_logged_in_school_id] = { :value => @current_school_id, :expires => 1.year.from_now, :domain => ".learningearnings.com"}
  end
end
