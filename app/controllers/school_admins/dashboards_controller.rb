module SchoolAdmins
  class DashboardsController < SchoolAdmins::BaseController

    def new_student
      @student = Student.new
    end
   
    def create_student
      @student = Student.new(params[:student])
      if @student.save
        @student.user.update_attributes(username: params[:student][:username], password: params[:student][:password], password_confirmation: params[:student][:password_confirmation])
        @student.school = current_school
        flash[:notice] = 'Person created!'
        redirect_to school_admins_dashboard_path
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
        @teacher.user.update_attributes(username: params[:teacher][:username], password: params[:teacher][:password], password_confirmation: params[:teacher][:password_confirmation])
        @teacher.school = current_school
        @teacher.activate
        flash[:notice] = 'Person created!'
        redirect_to school_admins_dashboard_path
      else
        flash.now[:error] = 'Person not created'
        render :new
      end
    end

  end
end


