class FaqQuestionsController < LoggedInController

  def index
    get_questions.order(:place)
  end

  def create
    if params[:faq_question_search][:search].present?
      @questions = FaqQuestion.kinda_matching(params[:faq_question_search][:search]).order(:place)
      render :partial => "faq_search_results", :locals => {:questions => @questions}
    else
      get_questions
      @questions.kinda_matching(params[:faq_question_search][:search]).order(:place)
      render :partial => "faq_search_results", :locals => {:questions => @questions}
    end
  end

  def get_questions
    if current_person.is_a?(Student)
      @questions = FaqQuestion.for_student
    elsif current_person.is_a?(SchoolAdmin)
      @questions = FaqQuestion.for_school_admin
    elsif current_person.is_a?(Teacher)
      @questions = FaqQuestion.for_teacher
    end
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
  
  

end
