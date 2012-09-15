class FiltersController < ApplicationController
  respond_to :js

  def filter_schools_by_state
    if params[:states]
      @states = params[:states].map { |state_id| State.find_by_id state_id.to_i }
      @schools = School.for_states(@states)
    else
      @schools = []
    end
    render :respond_with => [@schools, @states]
  end

  def filter_classrooms_by_school
    if params[:schools]
      @classrooms = Classroom.where(:school_id => params[:schools])
    else
      @classrooms = []
    end
    render :respond_with => @classrooms
  end

  def filter_grades_by_classroom
    @grades = School::GRADES
    render :respond_with => @grades
  end
end
