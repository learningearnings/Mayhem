class Mobile::V1::Teachers::GoalsController < Mobile::V1::Teachers::BaseController
  def index
    @goals = current_person.otu_code_categories(current_school.id)
  end
  def update
    
    @occ = OtuCodeCategory.find(params[:id])
    @occ.name = params[:goal][:name]
    @occ.save
    
    @goal = ClassroomOtuCodeCategory.where(classroom_id: params[:goal][:classroom_id], otu_code_category_id: params[:id]).first_or_create
    @goal.value = params[:goal][:value]
    @goal.save
    
    render json: { status: :ok }
  end 
   
  def create
    @occ = OtuCodeCategory.new
    @occ.name = params[:goal][:name] 
    @occ.otu_code_type_id = 4  
    @occ.person = current_person 
    @occ.save
    
    @goal = ClassroomOtuCodeCategory.new
    @goal.otu_code_category_id = @occ.id
    @goal.value = params[:goal][:value]
    @goal.classroom_id = params[:goal][:classroom_id]
    @goal.save
    
    render json: { status: :ok, goal: @occ.id }
  end
end
