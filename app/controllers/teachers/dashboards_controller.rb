module Teachers
  class DashboardsController < Teachers::BaseController

    def new_student
      @student = Student.new
    end
   
    def create_student
      @student = Student.new(params[:student])
      if @student.save
        flash[:notice] = 'Student created!'
        redirect_to teachers_dashboard_path
      else
        flash.now[:error] = 'Student not created'
        render :new
      end
    end

    def edit_student
      @student = Student.find(params[:id])
    end

    def update_student
      @classroom = Classroom.find(params[:classroom_id])
      @student = Student.find(params[:student][:id])
      if @student.update_attributes(params[:student])
        flash[:notice] = 'Student updated!'
        redirect_to classroom_path(@classroom)
      else
        flash.now[:error] = 'Student not updated'
        render :show
      end
    end

    def show
      @classroom = Classroom.find(params[:classroom_id])
      @student = Student.find(params[:id])
    end

  end
end


