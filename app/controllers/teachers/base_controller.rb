module Teachers
  class BaseController < LoggedInController
    before_filter :redirect_unless_teacher

    protected
    def redirect_unless_teacher
      redirect_to(root_path, flash: { notice: "Only teachers can do that." }) unless current_person.is_a?(Teacher)
    end
  end
end
