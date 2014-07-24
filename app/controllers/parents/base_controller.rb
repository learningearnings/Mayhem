module Parents
 class BaseController < LoggedInController 
    before_filter :redirect_unless_parent

    protected
    def redirect_unless_parent
      unless current_person.is_a?(Parent) || current_person.is_a?(SchoolAdmin)
        redirect_to(root_path, flash: { notice: "Only parents can do that." })
      end
    end
 end
end
