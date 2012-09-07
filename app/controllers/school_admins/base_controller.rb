module SchoolAdmins
  class BaseController < LoggedInController
    before_filter :redirect_unless_school_admin

    protected
    def redirect_unless_school_admin
      redirect_to(root_path, flash: { notice: "Only school admins can do that." }) unless current_person.is_a?(SchoolAdmin)
    end
  end
end
