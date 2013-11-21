module Teachers
  class BulkStudentsController < Teachers::BaseController
    before_filter :load_edit, only: [:edit, :update]

    def show
    end

    def new
    end

    def edit
    end

    def update
      updater_method = params["form_action_hidden_tag"] == "Delete these students" ? :delete! : :call
      #@batch_student_updater = BatchStudentUpdater.new(params["students"], current_person.schools.first)
      StudentUpdaterWorker.perform_async(params["students"], current_person.schools.first, updater_method)
      #if @batch_student_updater.send(updater_method)
        flash[:notice] = "Bulk process is running."
        redirect_to action: :show
      #else
      #  flash[:error] = "Error updating students"
      #  render action: :edit
      #end
    end

    def create
      @batch_student_creator = BatchStudentCreator.new(params["students"], current_person.schools.first)
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

      @students = current_school.students
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
