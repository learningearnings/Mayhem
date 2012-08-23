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
      PersonSchoolLink.create(:person_id => @student.id, :school_id => @school.id)
      redirect_to admin_student_path(@student)
    end

    def create
      @school = School.find_by_name(params[:school])
      @student = Student.new(params[:student])
      if @student.save
        PersonSchoolLink.create(:person_id => @student.id, :school_id => @school.id)
        flash[:notice] = 'Student created.'
        redirect_to admin_student_path(@student)
      else
        flash[:error] = 'Student not created.'
        render 'form'
      end
    end

    def delete_school_link
      @student = Student.find(params[:student])
      @school = School.find(params[:school])
      link = PersonSchoolLink.find_by_person_id_and_school_id(@student.id, @school.id)
      if link.delete
        redirect_to admin_student_path(@student)
      else
        render 'show'
      end
    end

    def form
      @student = Student.new(params[:student])
    end
  end
  
end
