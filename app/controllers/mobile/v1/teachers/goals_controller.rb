class Mobile::V1::Teachers::GoalsController < Mobile::V1::Teachers::BaseController
  def index
    #@goals = OtuCodeCategory.where(person_id: current_person.id, school_id: current_school.id)
    @goals = current_person.otu_code_categories(current_school.id)    
  end
  
  def update
    
    @occ = OtuCodeCategory.find(params[:id])
    if params[:goal].blank?
      @occ.name = params[:name]
      @occ.value = params[:value]
    else
      @occ.name = params[:goal][:name]
      @occ.value = params[:goal][:value]
    end
    @occ.name = "" if @occ.name.blank?
    @occ.save
    
    if params[:goal] and params[:goal][:classroom_id]
      @goal = ClassroomOtuCodeCategory.where(classroom_id: params[:goal][:classroom_id], otu_code_category_id: params[:id]).first_or_create
      @goal.value = params[:goal][:value]
      @goal.save
    end
    
    render json: { status: :ok }
  end 
   
  def create
    @occ = OtuCodeCategory.new
    if params[:goal].blank?
      @occ.name = params[:name]
      @occ.value = params[:value]
    else
      @occ.name = params[:goal][:name]
      @occ.value = params[:goal][:value]
    end
    @occ.name = "" if @occ.name.blank?
    @occ.otu_code_type_id = 4  
    @occ.school = current_school
    @occ.person = current_person 
    @occ.save
    
    if params[:goal] and params[:goal][:classroom_id]
      @goal = ClassroomOtuCodeCategory.new
      @goal.otu_code_category_id = @occ.id
      @goal.value = params[:goal][:value]
      @goal.classroom_id = params[:goal][:classroom_id]
      @goal.save
    end
    
    render json: { status: :ok, goal: @occ.id }
  end
  
  def destroy
    @occ = OtuCodeCategory.find(params[:id])
    if @occ.person_id.blank? or !(@occ.person_id == current_person.id)
      render json: { status: :error, msg: "You cannot delete a credit category you did not create"} and return
    end
    @occ.destroy
    render json: { status: :ok }
  end
end
