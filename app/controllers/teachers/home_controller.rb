module Teachers
  class HomeController < LoggedInController
    def show
      @new_features = ReleaseNote.published.featured.most_recent
      @teacher_email_form = TeacherEmailForm.new(:person_id => current_person.id)
    end
    
    def save
      @teacher_email_form = TeacherEmailForm.new(params[:teacher])
      if @teacher_email_form.save
        redirect_to :action => :show
      else
        render :show
      end
    end
    
    def defer_email
      session[:defer_email] = true
      redirect_to :action => :show
    end

  end
end
