class Mobile::V1::Teachers::GoalsController < Mobile::V1::Teachers::BaseController
  def index
    @goals = current_person.otu_code_categories(current_school.id)
  end
end
