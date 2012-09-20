Spree::UserSessionsController.class_eval do
  def create
    authenticate_user!

    if user_signed_in?
      respond_to do |format|
        format.html {
          flash.notice = t(:logged_in_succesfully)
          if current_user.person && current_user.person.is_a?(Student)
            redirect_to '/'
          elsif current_user.person && current_user.person.is_a?(Teacher)
            redirect_to main_app.teachers_home_path
         elsif current_user.person && current_user.person.is_a?(SchoolAdmin)
            redirect_to '/'
          elsif current_user.person && current_user.person.is_a?(LeAdmin)
            redirect_to  "/admin/le_admin_dashboard"
          elsif !current_user.person
            redirect_to '/store/admin'
          end
        }
        format.js {
          user = resource.record
          render :json => {:ship_address => user.ship_address, :bill_address => user.bill_address}.to_json
        }
      end
    else
      flash.now[:error] = t('devise.failure.invalid')
      render :new
    end
  end
end
