class Mobile::V1::Students::ProfileController < Mobile::V1::Students::BaseController
  def show
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])
    @student.first_name = params[:student][:first_name]
    @student.last_name = params[:student][:last_name]
    if @student.save
      render json: { status: :ok }
    else
      render json: { status: :unprocessible_entity }
    end
  end  
end
