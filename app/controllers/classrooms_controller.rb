class ClassroomsController < LoggedInController
  before_filter :load_classrooms, only: [:index, :create]

  def index
  end

  def new
    @classroom = Classroom.new(params[:classroom])
  end

  def show
    @classroom = Classroom.find(params[:id])
    @classroom_student_form = ClassroomStudentForm.new
    respond_to do |format|
      format.html { render layout: true }
      format.json { render json: @classroom.students.order(:last_name, :first_name) }
    end
  end

  def edit
    @classroom = Classroom.find(params[:id])
  end

  def update
    @classroom = Classroom.find(params[:id])
    if @classroom.update_attributes(params[:classroom])
      redirect_to @classroom
      flash[:notice] = 'Classroom was updated.'
    else
      render :new
      flash[:error] = 'There was a problem updating the classroom.'
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
        MixPanelTrackerWorker.perform_async(current_user.id, 'Remove Student from Classroom')
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
      psl = @student.person_school_links.where(school_id: @classroom.school.id).first
      PersonSchoolClassroomLink.where(:person_school_link_id => psl.id, homeroom: true).delete_all if params[:homeroom] == "true"
      pscl = PersonSchoolClassroomLink.new(:classroom_id => @classroom.id, :person_school_link_id => psl.id, homeroom: params[:homeroom])
      if pscl.save
        respond_to do |format|
          format.html {
            flash[:notice] = "Student added to classroom."
            MixPanelTrackerWorker.perform_async(current_user.id, 'Add Student to Classroom')
            redirect_to classroom_path(@classroom)
          }
          format.json { render json: @classroom.students, each_serializer: ClassroomStudentSerializer, classroom_id: @classroom.id, school_id: @classroom.school.id, root: false }
        end
      else
        respond_to do |format|
          format.html {
            flash[:error] = pscl.errors.full_messages.to_sentence
            render :show
          }
          format.json { render :json => {:status => 400, :result => 'error', :flash => 'There was an error adding student to classroom.', :request => classroom_path(@classroom) } }
        end
      end
    else
      flash[:error] = 'Please pick a student.'
      redirect_to :back
    end
  end

  def create
    classroom_creator = ClassroomCreator.new(params[:classroom][:name], current_person, current_school)
    classroom_creator.execute!
    if classroom_creator.success?
      MixPanelTrackerWorker.perform_async(current_user.id, 'Add Classroom')
      respond_to do |format|
        format.html {
          flash[:notice] = "Classroom Created."
          redirect_to classrooms_path
        }
        format.json {
          render json: {
            status: :ok,
            classroom: classroom_creator.classroom,
            classrooms: current_person.classrooms.order('name ASC').uniq
          }
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Classroom not created."
          render :index
        }
        format.json { render json: { status: :unprocessible_entity, notice: 'Classroom not created.' } }
      end
    end
  end

  def destroy
    classroom_deactivator = ClassroomDeactivator.new(params[:id])
    if classroom_deactivator.execute!
      flash[:notice] = 'Classroom deleted.'
      redirect_to classrooms_path
    end
  end

  def create_student
    @classroom_student_form = ClassroomStudentForm.new
    @classroom = Classroom.find(params[:classroom_id])
    @classroom_student_form.set_values(params[:classroom_id], params[:user])
    if @classroom_student_form.save
      render json: @classroom_student_form.classroom.students,
        each_serializer: ClassroomStudentSerializer,
          classroom_id: @classroom_student_form.classroom.id,
          school_id: @classroom_student_form.classroom.school.id,
          root: "students",
          meta: { status: :ok }
    else
      form = render_to_string partial: "add_new_student_form"
      render json: { modal: form, status: :unprocessible_entity }
    end
  end

  def load_classrooms
    @classrooms = current_person.classrooms_for_school(current_school).order("name ASC").uniq
  end

  def homeroom_check
    @student = Student.find(params[:student_id])
    @classroom = Classroom.find(params[:classroom_id])
    psl = @student.person_school_links.where(school_id: @classroom.school.id).first
    pscl = PersonSchoolClassroomLink.where(:person_school_link_id => psl.id, homeroom: true).first
    respond_to do |format|
      format.js do
        if pscl
          render :json => {:classroom => pscl.classroom}, :layout => false
        else
          render :json => {:classroom => nil}, :layout => false
        end
      end
    end

  end
end
