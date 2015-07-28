class Mobile::V1::Teachers::ProfileController < Mobile::V1::Teachers::BaseController
  def show
    # TODO: Fix slowness
    #@student = current_school.students.find(params[:id])
    @teacher = Teacher.find(params[:id])
  end

  def update
    @teacher = Teacher.find(params[:id])
    @teacher.first_name = params[:teacher][:first_name]
    @teacher.last_name = params[:teacher][:last_name]
    if @teacher.save
      render json: { status: :ok }
    else
      render json: { status: :unprocessible_entity }
    end
  end
end
