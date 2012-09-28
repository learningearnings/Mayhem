class HomesController < LoggedInController
  def show
    if current_user.person && current_user.person.is_a?(Student)
      redirect_to '/'
    elsif current_user.person && current_user.person.is_a?(Teacher)
      redirect_to main_app.teachers_home_path
   elsif current_user.person && current_user.person.is_a?(SchoolAdmin)
      redirect_to '/'
    elsif current_user.person && current_user.person.is_a?(LeAdmin)
      redirect_to  "/admin/le_admin_dashboard"
    elsif !current_user.person
      redirect_to '/store/admin'
    end
  end
end
