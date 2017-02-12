module Powerschool
  class Assignment < PowerschoolObject
    attr_accessor(:id, :name, :abbreviation, :description, :points_possible, :extra_credit_points,
                  :include_final_grades, :weight, :category, :scoring_type, :date_assignment_due, :publish_state,
                  :publish_scores )
  end
end