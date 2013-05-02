Spree::UserSessionsController.class_eval do
  def create
    authenticate_user!

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
      flash[:error] = t('devise.failure.invalid')
      redirect_to main_app.page_path('home')
#      render :new
    end
  end
end
