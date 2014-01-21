require 'common_person_config'
ActiveAdmin.register Student do
  include CommonPersonConfig
  menu :parent => "Schools", :priority => 3

  controller do
    def create
      create! do |format|
        format.html { redirect_to admin_student_path(resource) }
      end
    end
  end
end
