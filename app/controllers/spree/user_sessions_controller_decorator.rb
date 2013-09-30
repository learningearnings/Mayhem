Spree::UserSessionsController.class_eval do
  def create
    authenticate_user!
    session[:last_school_id] = params[:user]["school_id"]
    session[:current_school_id] = params[:user]["school_id"]

    if user_signed_in?
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
#      render :new
    end
  end
 
  def new
    redirect_to main_app.page_path('home')
  end 
end
