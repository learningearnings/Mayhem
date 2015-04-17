class Mobile::V1::Teachers::AwardsController < Mobile::V1::Teachers::BaseController
  def index
    # TODO: Figure out why .order isn't working
    @awards = current_person.otu_code_categories(current_school.id).sort_by{ |x| x.name }
  end
end
