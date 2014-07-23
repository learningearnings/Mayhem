module Parents
  class RegistrationsController < BaseController
    skip_before_filter :authenticate_user!
    skip_before_filter :redirect_unless_parent

    def new
      @parent = Parent.new params[:parent]
    end

    def create
      @parent = Parent.new params[:parent]
      @parent_student_link = ::ParentStudentLink.where(guid: session[:parent_student_guid]).first
      if @parent.save && @parent.user.update_attribute(:username, params[:parent][:username])
        flash[:notice] = "You have been registered! You may now sign in."
        redirect_to parents_home_path
      else
        flash.now[:notice] = "There was a problem registering your account"
        render :new
      end
    end
  end
end
