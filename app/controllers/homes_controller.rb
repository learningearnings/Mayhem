class HomesController < ApplicationController
  def show
    if !current_user
      redirect_to '/pages/home' and return
    end
    if !current_user.person
      redirect_to '/store/admin' and return
    end
    person = current_user.person
    if person.is_a?(Student)
      redirect_to main_app.students_home_path
    elsif person.is_a?(SchoolAdmin)
      redirect_to main_app.school_admins_bank_path
    elsif person.is_a?(Teacher)
      redirect_to main_app.teachers_bank_path
    elsif person.is_a?(LeAdmin)
      redirect_to  "/admin/le_admin_dashboard"
    end
  end
  
  def schools_for_username
    @username = params[:username]
    @schools = School.where(id: PersonSchoolLink.where(person_id: Person.with_username(@username).pluck(:id)).pluck(:school_id), status: "active" ).order(:name)
    if @schools.size == 0
      @schools = School.where(" district_guid is not null and status = 'active' ").order(:name)
    end    
    render :partial => 'pages/school_select'
  end
end