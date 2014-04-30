ActiveAdmin.register_page "New Teachers Requests" do
  #menu :priority => 6

  controller do
    def index
      @teachers = Teacher.awaiting_approval
    end

    def activate
      @teacher = Teacher.find params[:id]
      @teacher.activate
      redirect_to '/admin/new_teachers_requests'
    end

    def deny
      @teacher = Teacher.find params[:id]
      if @teacher.destroy
        flash[:notice] = "Teacher was removed."
        redirect_to '/admin/new_teachers_requests'
      else
        flash[:error] = "Teacher was removed."
        redirect_to :back
      end
    end
  end

  content do
    render "index"
  end


end
