module Parents
  class HomeController < LoggedInController
    before_filter :check_for_parent_student_guid

    def show
    end

    private
    def check_for_parent_student_guid
      if session[:parent_student_guid]
        redirect_to link_child_parents_children_path(:guid => session[:parent_student_guid])
      end
    end
  end
end
