class FaqQuestionsController < ApplicationController

  def index
    if current_person.is_a?(Student)
      @questions = FaqQuestion.for_student
    elsif current_person.is_a?(Teacher)
      @questions = FaqQuestion.for_teacher
    end
  end

  def create
    @questions = FaqQuestion.search_any_word(params[:faq_question_search][:search])
    render :partial => "faq_search_results"
  end

end
