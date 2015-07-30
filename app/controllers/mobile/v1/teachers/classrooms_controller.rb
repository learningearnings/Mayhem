class Mobile::V1::Teachers::ClassroomsController < Mobile::V1::Teachers::BaseController
  def index
    @classrooms = current_person.classrooms_for_school(current_school)
  end

  def show
    @classroom = current_person.classrooms.find(params[:id])
  end

  def update
    # Currently, only saving name
    @classroom = Classroom.find(params[:id])
    @classroom.name = params[:name]
    if @classroom.save
      render json: { status: :ok }
    else
      render json: { status: :unprocessible_entity }
    end
  end

  def create
    # TODO: Fix this
    classroom_creator = ClassroomCreator.new(params[:classroom][:name], current_person, current_school)
    classroom_creator.execute!
    classroom = classroom_creator.classroom

    classroom.save

    render json: { status: :ok }
  end

  def remove_student
    # TODO: Move to class
    psl = PersonSchoolLink.where(person_id: params[:studentId], school_id: current_school.id).first
    pscl = PersonSchoolClassroomLink.where(person_school_link_id: psl.id, classroom_id: params[:id]).first
    if pscl.update_attribute(:status, "inactive")
      render json: { status: :ok }
    else
      render json: { status: :unprocessible_entity }
    end
  end

  def add_students
    # TODO: Fix this so that we can render correct response
    # TODO: Move to class
    params[:studentIds].each do |student_id|
      psl = PersonSchoolLink.where(person_id: student_id, school_id: current_school.id).first
      pscl = PersonSchoolClassroomLink.where(person_school_link_id: psl.id, classroom_id: params[:id]).first_or_initialize
      pscl.update_attribute(:status, "active")
    end

    render json: { status: :ok }
  end

  def remove_goal
    # TODO: Set status, don't delete (possibly)
    @classroom_otu_code_category = ClassroomOtuCodeCategory.where(classroom_id: params[:id], otu_code_category_id: params[:goalId]).first
    if @classroom_otu_code_category and @classroom_otu_code_category.destroy
      render json: { status: :ok }
    else
      render json: { status: :unprocessible_entity }
    end
  end

  def add_goals
    params[:goalIds].each do |goal_id|
      @classroom_otu_code_category = ClassroomOtuCodeCategory.where(classroom_id: params[:id], otu_code_category_id: goal_id).first_or_create
    end

    render json: { status: :ok }
  end
end
