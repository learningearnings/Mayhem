ActiveAdmin.register School do
 
  show do
    @school = School.find(params[:id])
    render 'school_show'
  end
 
end
