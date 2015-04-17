class Mobile::V1::Students::ClassroomsController < Mobile::V1::Students::BaseController
  def index
    @classrooms = current_person.classrooms_for_school(current_school)
  end

  def show
    @classroom = Classroom.find(params[:id])
  end
end
