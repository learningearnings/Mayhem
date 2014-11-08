class FaqQuestionsController < LoggedInController
  before_filter :set_questions

  def index
    @release_notes = ReleaseNote.published
  end

  def search
    questions = params[:search][:q].present? ? @questions.kinda_matching(params[:search][:q]) : @questions
    render partial: "faq_search_results", locals: { questions: questions }
  end

  private

  def set_questions
    @questions ||= FaqQuestion.for_person_type(current_person.type).order(:place)
  end
end
