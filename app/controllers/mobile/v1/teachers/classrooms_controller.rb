class Mobile::V1::Teachers::ClassroomsController < Mobile::V1::Teachers::BaseController
  def index
    render json: current_person.classrooms_for_school(current_school), each_serializer: Mobile::Teachers::ClassroomSerializer, root: false
  end

  def show
    render json: current_person.classrooms.find(params[:id]), serializer: Mobile::Teachers::ClassroomSerializer, root: false
  end

  def create
    # TODO: Do stuff here
    render json: { status: :ok }
  end
end
