class Mobile::V1::Parents::ProfileController < Mobile::V1::Parents::BaseController
  def show
    # TODO: Fix slowness
    #@student = current_school.students.find(params[:id])
    @parent = Parent.find(params[:id])
  end

  def update
    @parent = Parent.find(params[:id])
    if @parent.update_attributes(first_name: params[:parent][:first_name], last_name: params[:parent][:last_name], relationship: params[:parent][:relationship], phone: params[:parent][:phone])
      render json: { status: :ok }
    else
      render json: { status: :unprocessible_entity }
    end
  end

end
