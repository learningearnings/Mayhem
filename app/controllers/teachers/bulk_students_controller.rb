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
      @batch_student_creator = BatchStudentCreator.new(params["students"])
      if @batch_student_creator.call
        @batch_student_creator.students.each do |student|
          PersonSchoolLink.find_or_create_by_person_id_and_school_id(student.id, current_person.schools.first.id)
        end
        flash[:notice] = "Students Created!"
        redirect_to action: :index
      else
        flash[:error] = "Error creating students"
        render action: :index
      end
    end
  end
end
