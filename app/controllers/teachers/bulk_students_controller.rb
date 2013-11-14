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
      binding.pry
      @batch_student_updater = BatchStudentUpdater.new(params["students"])
      if @batch_student_updater.call
        flash[:notice] = "Students Updated!"
        redirect_to action: :show
      else
        flash[:error] = "Error updating students"
        render action: :edit
      end
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
        "Update Passwords as Indicated"
      ]
      @students = current_school.students
    end
  end
end
