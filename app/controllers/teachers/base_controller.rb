module Teachers
  class BaseController < LoggedInController
    before_filter :redirect_unless_teacher

    protected
    def redirect_unless_teacher
      unless current_person.is_a?(Teacher) || current_person.is_a?(SchoolAdmin)
        redirect_to(root_path, flash: { notice: "Only teachers can do that." })
      end
    end
  end
end
