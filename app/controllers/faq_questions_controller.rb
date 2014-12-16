class FaqQuestionsController < LoggedInController
  before_filter :set_questions

  def index
    @release_notes = ReleaseNote.published
  end

  def search
    questions = params[:search][:q].present? ? @questions.kinda_matching(params[:search][:q]) : @questions
    render partial: "faq_search_results", locals: { questions: questions }
  end
  
  def tour

  end
  
  def begin_tour
    session[:tour] = "Y"
    if current_person.is_a?(Student)
      redirect_to main_app.inbox_path
    elsif current_person.is_a?(SchoolAdmin)
      redirect_to main_app.school_admins_bank_path      
    elsif current_person.is_a?(Teacher)
      redirect_to main_app.teachers_bank_path
    else
      redirect_to main_app.home_path
    end
    
  end
  
  def end_tour
    session[:tour] = nil
    redirect_to main_app.home_path
  end
  
  private

  def get_questions
    if current_person.is_a?(Student)
      @questions = FaqQuestion.for_student
    elsif current_person.is_a?(SchoolAdmin)
      @questions = FaqQuestion.for_school_admin
    elsif current_person.is_a?(Teacher)
      @questions = FaqQuestion.for_teacher
    end
  end
  
  def set_questions
    @questions ||= FaqQuestion.for_person_type(current_person.type).order(:place)
  end
end
