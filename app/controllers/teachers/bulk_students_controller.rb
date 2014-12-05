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
        importer = StudentsImporter.new(params[:school_id], params[:file])
        importer.call
        flash[:notice] = 'Students have been submitted.'
      rescue Exception => e
        flash[:error] = "Students import failed. Error #{e.message}"
      ensure
        redirect_to teachers_bulk_students_path
      end
    end

    def update
      updater_method = params["form_action_hidden_tag"] == "Delete these students" ? :delete! : :call
      delayed_report = DelayedReport.create(person_id: current_person.id)
      StudentUpdaterWorker.perform_async(params["students"], current_school.id, updater_method, delayed_report.id)
      
      respond_to do |format|
        format.json { render json: { delayed_report_id: delayed_report.id } }
      end
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
        "Edit Student Information"
      ]

      # FIXME: This needs to be dealt with in a better manner
      @actions.push("Delete these students") unless current_person.synced?

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
