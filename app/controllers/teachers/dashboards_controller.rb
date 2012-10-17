module Teachers
  class DashboardsController < Teachers::BaseController

    def new_student
      @student = Student.new
    end
   
    def create_student
      @student = Student.new(params[:student])
      if @student.save
        flash[:notice] = 'Person created!'
        redirect_to teachers_dashboard_path
      else
        flash.now[:error] = 'Person not created'
        render :new
      end
    end

    def show
      @student = Student.find(params[:student_id])
    end

  end
end


