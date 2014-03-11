module Teachers
  class BulkTeachersController < Teachers::BaseController
    before_filter :load_edit, only: [:edit, :update]

    def show
    end

    def new
    end

    def edit
    end

    def update
      updater_method = params["form_action_hidden_tag"] == "Delete these teachers" ? :delete! : :call
      TeacherUpdaterWorker.perform_async(current_person.user.email, params["teachers"], current_person.schools.first, updater_method)
      flash[:notice] = "Bulk process is running."
      redirect_to action: :show
    end

    def create
      @batch_teacher_creator = BatchTeacherCreator.new(params["teachers"], current_person.schools.first)
      if @batch_teacher_creator.call
        flash[:notice] = "Teachers Created!"
        redirect_to action: :show
      else
        flash[:error] = "Error creating teachers"
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
        "Edit Teachers Information",
        "Delete these teachers"
      ]

      @teachers = current_school.teachers
      if params[:classroom].present?
        classroom = Classroom.find(params[:classroom])
        @teachers = classroom.teachers
      end

      if params[:gender].present?
        @teachers = @teachers.for_gender(params[:gender])
      end

      @teachers = @teachers.for_grade(params[:grade]) if params[:grade].present?
    end
  end
end
