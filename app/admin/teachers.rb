ActiveAdmin.register Teacher do

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

  end
  
end
