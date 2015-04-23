class Mobile::V1::Teachers::StudentsController < Mobile::V1::Teachers::BaseController
  def index
    @students = current_school.students
  end

  def show
    # TODO: Fix slowness
    #@student = current_school.students.find(params[:id])
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])
    @student.first_name = params[:student][:first_name]
    @student.last_name = params[:student][:last_name]
    if @student.save
      render json: { status: :ok }
    else
      render json: { status: :unprocessible_entity }
    end
  end

  def add_classrooms
    @student = Student.find(params[:id])
    psl = PersonSchoolLink.where(person_id: @student.id, school_id: current_school.id).first
    params[:classroom_ids].each do |classroom_id|
      pscl = PersonSchoolClassroomLink.where(person_school_link_id: psl.id, classroom_id: classroom_id).first_or_initialize
      pscl.status = "active"
      pscl.save
    end
    render json: { status: :ok }
  end
end
