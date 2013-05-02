module SchoolAdmins
  class DashboardsController < SchoolAdmins::BaseController

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
    end

    def new_teacher
      @teacher = Teacher.new
    end
 
    def create_teacher
      @teacher = Teacher.new(params[:teacher])
      if @teacher.save
        flash[:notice] = 'Person created!'
        redirect_to school_admins_dashboard_path
      else
        flash.now[:error] = 'Person not created'
        render :new
      end
    end

  end
end


