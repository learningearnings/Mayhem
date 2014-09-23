module Teachers
  class BulkStudentsController < Teachers::BaseController
    before_filter :load_edit, only: [:edit, :update]

    def show
    end

    def new
    end

    def edit
    end

    def import_students
      begin
        raise "Please upload a spreadsheet first" if params[:file].nil?
        importer = StudentsImporter.new(params[:school_id], params[:file])
        importer.call
        flash[:notice] = 'Students have been submitted.'
      rescue Exception => e
        flash[:error] = "Students import failed. #{e.message}"
      ensure
        redirect_to teachers_bulk_students_path
      end
    end

    def update
      updater_method = params["form_action_hidden_tag"] == "Delete these students" ? :delete! : :call
      StudentUpdaterWorker.perform_async(current_person.user.email, params["students"], current_school.id, updater_method)
      flash[:notice] = "Bulk process is running."
      redirect_to action: :show
    end

    def create
      @batch_student_creator = BatchStudentCreator.new(params["students"], current_school)
      if @batch_student_creator.call
        flash[:notice] = "Students Created!"
        redirect_to action: :show
      else
        flash[:error] = "Error creating students"
        render action: :new
      end
    end

    protected
    def load_edit
      @actions = [
        "Update Passwords to this Password",
        "Update Passwords = Usernames",
        "Update Passwords as Indicated",
        "Add to Classroom I select:",
        "Edit Students Information",
        "Delete these students"
      ]

      @students = current_school.students.includes(:user)
      if params[:classroom].present?
        classroom = Classroom.find(params[:classroom])
        @students = classroom.students
      end

      if params[:gender].present?
        @students = @students.for_gender(params[:gender])
      end

      @students = @students.for_grade(params[:grade]) if params[:grade].present?
    end
  end
end
