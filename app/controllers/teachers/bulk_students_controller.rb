module Teachers
  class BulkStudentsController < Teachers::BaseController
    def index
    end

    def new
    end

    def edit
    end

    def update
    end

    def create
      batch_student_creator = BatchStudentCreator.new(params["students"])
      if batch_student_creator.call
        flash[:notice] = "Students Created!"
        redirect_to :index
      else
        flash[:error] = "Error creating students"
        render :index
      end
    end
  end
end
