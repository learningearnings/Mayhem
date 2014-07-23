module Parents
  class ChildrenController < BaseController
    def link_child
      parent_student_link = ::ParentStudentLink.where(guid: params[:guid], state: "unlinked").first
      if  parent_student_link.present?
        parent_student_link.parent = current_person
        parent_student_link.link!
        flash[:notice] = "You have been linked with your child."
      end
      redirect_to main_app.parents_home_path
    end
  end
end

