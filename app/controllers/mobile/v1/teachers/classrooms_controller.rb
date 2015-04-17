class Mobile::V1::Teachers::ClassroomsController < Mobile::V1::Teachers::BaseController
  def index
    @classrooms = current_person.classrooms_for_school(current_school)
  end

  def show
    @classroom = current_person.classrooms.find(params[:id])
  end

  def create
    # TODO: Do stuff here
    render json: { status: :ok }
  end
end
