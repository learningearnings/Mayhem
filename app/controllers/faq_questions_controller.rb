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
    if current_person.is_a?(Student)
      redirect_to "/inbox/teacher_messages?tour=Y"
    elsif current_person.is_a?(SchoolAdmin) 
      redirect_to "/school_admins/bank?tour=Y"    
    elsif current_person.is_a?(Teacher)
      redirect_to "/teachers/bank?tour=Y"
    else
      redirect_to main_app.home_path
    end
    
  end
  
  def end_tour
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
