class Mobile::V1::Teachers::StudentsController < Mobile::V1::Teachers::BaseController
  def index
    @students = current_school.students
  end

  def show
    # TODO: Fix slowness
    #@student = current_school.students.find(params[:id])
    @student = Student.find(params[:id])
  end
end
