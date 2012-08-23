ActiveAdmin.register Student do

  form :partial => "form"

  show do
    @student = Student.find(params[:id])
    render 'school_list'
  end

  controller do

    def update
      @student = Student.find(params[:id])
      @school = School.find_by_name(params[:school])
      PersonSchoolLink.create(:person_id => @teacher.id, :school_id => @school.id)
      redirect_to 'show'
    end

    def create
      @school = School.find_by_name(params[:school])
      @student = Student.new(params[:student])
      if @student.save
        PersonSchoolLink.create(:person_id => @student.id, :school_id => @school.id)
        flash[:notice] = 'Student created.'
        redirect_to 'show'
      else
        flash[:error] = 'Student not created.'
        render 'form'
      end
    end

    def form
      @student = Student.new(params[:student])
    end


  end
  
end
