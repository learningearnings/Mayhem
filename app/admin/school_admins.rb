require 'common_person_config'

ActiveAdmin.register SchoolAdmin do
  include CommonPersonConfig
  menu :parent => "Schools", :priority => 2

  controller do
    def create
      create! do |format|
        format.html { redirect_to admin_school_admin_path @school_admin}
      end
    end
    def update
      update! do |format|
        format.html { redirect_to admin_school_admins_path }
      end
    end
  end
end
