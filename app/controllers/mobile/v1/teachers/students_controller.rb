class Mobile::V1::Teachers::StudentsController < Mobile::V1::Teachers::BaseController
  def show
    render json: current_school.students.find(params[:id]), serializer: Mobile::Teachers::StudentSerializer, root: false
  end
end
