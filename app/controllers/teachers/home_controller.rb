module Teachers
  class HomeController < LoggedInController
    def show
      @new_features = ReleaseNote.published.featured.most_recent
      @teacher_email_form = TeacherEmailForm.new(:person_id => current_person.id)
    end
    
    def save
      @teacher_email_form = TeacherEmailForm.new(params[:teacher])
      @teacher_email_form.save
      redirect_to :action => :show
    end
  end
end
