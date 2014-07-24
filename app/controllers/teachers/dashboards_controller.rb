module Teachers
  class DashboardsController < Teachers::BaseController
    def new_student
      @student = Student.new
    end

    def create_student
      @student = Student.new(params[:student])
      if @student.save
        @student.user.update_attributes(username: params[:student][:username], password: params[:student][:password], password_confirmation: params[:student][:password_confirmation])
        @student.school = current_school
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
      @student = Student.find(params[:student].delete(:id))
      password = params[:student].delete(:password)
      if @student.update_attributes(params[:student])
        unless password.blank?
          user = @student.user
          user.password = password
          user.password_confirmation = password
          user.save
        end
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
      @orders = @student.user.orders
      # We need to just not show orders if there's no first product - this was causing an error
      @orders = @orders.reject do |o|
        begin
          o.products.empty?
        rescue
          true
        end
      end
    end

    def new_parent_student_link
      @parent_student_link = ParentStudentLink.new
    end

    def create_parent_student_link
      @parent_student_link = ParentStudentLink.new(student_id: params[:student_id])
      if @parent_student_link.save && params[:parent_email].present?
        ParentStudentLinkingMailer.link_with_your_child_email(params[:parent_email], @parent_student_link).deliver
        flash[:notice] = "The student has been linked and the parent has been notified!"
        redirect_to teachers_home_path
      else
        flash[:notice] = "Something went wrong linking the parent!"
        redirect_to teachers_new_parent_student_link_path
      end
    end
  end
end
