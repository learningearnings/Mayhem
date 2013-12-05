class ClassroomsController < LoggedInController
  before_filter :load_classrooms, only: [:index, :create]

  def index
  end

  def new
    @classroom = Classroom.new(params[:classroom])
  end

  def show
    @classroom = Classroom.find(params[:id])
    respond_to do |format|
      format.html { render layout: true }
      format.json { render json: @classroom.students.order(:last_name, :first_name)}
    end
  end

  def remove_student
    @student = Student.find(params[:student])
    @school = current_school
    @classroom = Classroom.find(params[:classroom])
    if psl = PersonSchoolLink.find_by_school_id_and_person_id(@school.id, @student.id)
      link = PersonSchoolClassroomLink.find_by_person_school_link_id_and_classroom_id(psl.id, @classroom.id)
      if link.delete
        flash[:notice] = "Student removed from classroom."
        redirect_to classroom_path(@classroom)
      else
        flash[:error] = "Student not removed from classroom."
        render :show
      end
    else
      flash[:error] = "Student not removed from classroom."
      render :show
    end
  end

  def add_student
    if params[:student_id].present?
      @student = Student.find(params[:student_id])
      @classroom = Classroom.find(params[:classroom_id])
      if @student<<(@classroom)
        flash[:notice] = "Student added to classroom."
        redirect_to classroom_path(@classroom)
      else
        flash[:error] = "Student not added to classroom."
        render :show
      end
    else
      flash[:error] = 'Please pick a student.'
      redirect_to :back
    end
  end

  def create
    @classroom = Classroom.new(params[:classroom])
    @classroom.school_id = current_school.id
    if @classroom.save
      current_person<<@classroom
      psl = PersonSchoolLink.find_by_person_id_and_school_id(current_person.id, current_school.id)
      pscl = PersonSchoolClassroomLink.find_by_classroom_id_and_person_school_link_id(@classroom.id, psl.id)
      pscl.activate
      pscl.update_attribute(:owner, true)
      flash[:notice] = "Classroom Created."
      redirect_to classrooms_path
    else
      flash[:error] = "Classroom not created."
      render :index
    end
  end

  def destroy
    @classroom = Classroom.find(params[:id])
    if @classroom.destroy
      pscls = PersonSchoolClassroomLink.find_all_by_classroom_id(@classroom.id)
      if pscls.present?
        pscls.map{|x| x.delete}
      end
      flash[:notice] = 'Classroom deleted.'
      redirect_to classrooms_path
    end
  end

  def create_student
    @classroom = Classroom.find(params[:classroom_id])
    @student = Student.new(params[:student])
    if @student.save
      @student.user.update_attributes(username: params[:student][:username], password: params[:student][:password], password_confirmation: params[:student][:password_confirmation])
      psl = PersonSchoolLink.find_or_create_by_person_id_and_school_id(@student.id, current_school.id)
      pscl = PersonSchoolClassroomLink.find_or_create_by_classroom_id_and_person_school_link_id(@classroom.id, psl.id)
      pscl.activate
      flash[:notice] = 'Student created!'
      redirect_to classroom_path(@classroom)
    else
      flash.now[:error] = 'Student not created'
      render :show
    end
  end

  def load_classrooms
    @classrooms = current_person.classrooms.uniq
  end
end
