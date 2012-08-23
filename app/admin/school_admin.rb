ActiveAdmin.register SchoolAdmin do

  form :partial => "form"

  show do
    @school_admin = SchoolAdmin.find(params[:id])
    render 'school_list'
  end

  controller do

    def update
      @school_admin = SchoolAdmin.find(params[:id])
      @school = School.find_by_name(params[:school])
      PersonSchoolLink.create(:person_id => @school_admin.id, :school_id => @school.id)
      redirect_to admin_school_admin_path(@school_admin)
    end

    def create
      @school = School.find_by_name(params[:school])
      @school_admin = SchoolAdmin.new(params[:school_admin])
      if @teacher.save
        PersonSchoolLink.create(:person_id => @school_admin.id, :school_id => @school.id)
        flash[:notice] = 'SchoolAdmin created.'
        redirect_to admin_school_admin_path(@school_admin)
      else
        flash[:error] = 'SchoolAdmin not created.'
        render 'form'
      end
    end

    def delete_school_link
      @school_admin = SchoolAdmin.find(params[:school_admin])
      @school = School.find(params[:school])
      link = PersonSchoolLink.find_by_person_id_and_school_id(@school_admin.id, @school.id)
      if link.delete
        redirect_to admin_school_admin_path(@school_admin)
      else
        render 'show'
      end
    end

    def form
      @school_admin = SchoolAdmin.new(params[:school_admin])
    end

  end
 
end
