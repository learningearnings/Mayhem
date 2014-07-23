module Parents
  class ChildrenController < BaseController
    prepend_before_filter :store_guid, :only => [:link_child]

    def link_child
      parent_student_link = ::ParentStudentLink.where(guid: params[:guid], state: "unlinked").first
      if  parent_student_link.present?
        parent_student_link.parent = current_person
        parent_student_link.link!
        flash[:notice] = "You have been linked with your child."
      end
      session[:parent_student_guid] = nil
      redirect_to main_app.parents_home_path
    end

    private
    def store_guid
      session[:parent_student_guid] = params[:guid]
    end
  end
end

