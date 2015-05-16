module Teachers
  class HomeController < LoggedInController
    def show
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
  end
end
