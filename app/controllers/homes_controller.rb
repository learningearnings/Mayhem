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
      redirect_to main_app.teachers_home_path
    elsif person.is_a?(Teacher)
      redirect_to main_app.teachers_home_path
    elsif person.is_a?(Parent)
      redirect_to main_app.parents_home_path
    elsif person.is_a?(LeAdmin)
      redirect_to  "/admin/le_admin_dashboard"
    end
  end
end
