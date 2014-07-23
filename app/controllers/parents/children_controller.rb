module Parents
  class ChildrenController < BaseController
    prepend_before_filter :redirect_if_not_logged_in, :only => [:link_child]

    def link_child
      parent_student_link = ::ParentStudentLink.where(guid: params[:guid], state: "unlinked").first
      if parent_student_link.present?
        parent_student_link.parent = current_person
        parent_student_link.link!
        flash[:notice] = "You have been linked with your child."
      end
      session[:parent_student_guid] = nil
      redirect_to main_app.parents_home_path
    end

    private
    def redirect_if_not_logged_in
      # Save guid
      if current_user.nil? || !current_person.is_a?(Parent)
        session[:parent_student_guid] = params[:guid]
        redirect_to new_parents_registration_path
      end
    end
  end
end

