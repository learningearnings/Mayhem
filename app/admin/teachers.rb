ActiveAdmin.register Teacher do

  form :partial => "form"

  show do
    @teacher = Teacher.find(params[:id])
    render 'school_list'
  end

  controller do

    def update
      @teacher = Teacher.find(params[:id])
      @school = School.find_by_name(params[:school])
      PersonSchoolLink.create(:person_id => @teacher.id, :school_id => @school.id)
      redirect_to 'show'
    end

    def create
      @school = School.find_by_name(params[:school])
      @teacher = Teacher.new(params[:teacher])
      if @teacher.save
        PersonSchoolLink.create(:person_id => @teacher.id, :school_id => @school.id)
        flash[:notice] = 'Teacher created.'
        redirect_to 'show'
      else
        flash[:error] = 'Teacher not created.'
        render 'form'
      end
    end

    def form
      @teacher = Teacher.new(params[:teacher])
    end

  end
  
end
