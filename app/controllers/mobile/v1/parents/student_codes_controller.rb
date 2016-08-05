class Mobile::V1::Parents::StudentCodesController < Mobile::V1::Parents::BaseController
  def index
    #current_person = Student.find(181357)
    @codes = Auction.viewable_for(current_person)
  end

  def create
    student = Student.find_by_parent_token(params[:student_code])
    if student
      student_with_parent = student.parents.where("parents_students.student_id = ? AND parents_students.parent_id = ?", student.id, current_person.id).any?
      if !student_with_parent
        student.parents << current_person
        if student.save
          render json: { status: :ok }
        else
          render json: { status: :unprocessible_entity }
        end  
      else
        render json: { error: 'Already added.' }, status: :unprocessible_entity and return 
      end  
    else
      logger.error("Invalid student code entered by #{current_person.first_name} #{current_person.last_name}") 
      render json: { error: 'Invalid Student Code.' }, status: :unprocessible_entity and return 
    end  
  end 
end
