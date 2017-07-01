class Mobile::V1::Students::ProfileController < Mobile::V1::Students::BaseController
  def show
    current_person = Student.find(181357)
    @student = Student.find(params[:id])
    @avatars = Avatar.all
  end

  def update
    @student = Student.find(params[:id])
    @student.first_name = params[:student][:first_name]
    @student.last_name = params[:student][:last_name]
    @student.avatar = Avatar.find(params[:avatar_id]) if !params[:avatar_id].blank?
    @student.avatar = Avatar.find(params[:student][:avatar_id]) if !params[:student][:avatar_id].blank?
    if @student.save
      render json: { status: :ok }
    else
      render json: { status: :unprocessible_entity }
    end
  end  
end
