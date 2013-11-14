module Teachers
  class BulkStudentsController < Teachers::BaseController
    def show
    end

    def new
    end

    def edit
      @actions = [
        "Update Passwords to this Password",
        "Update Passwords = Usernames",
        "Update Passwords as Indicated"
      ]
      @students = current_school.students
    end

    def update
      @batch_student_updater = BatchStudentUpdater.new(params["students"])
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
  end
end
