require 'common_person_config'

ActiveAdmin.register SchoolAdmin do
  include CommonPersonConfig
  menu :parent => "Schools", :priority => 2

  config.action_items.delete_if { |item| item.display_on?(:show) }
  action_item do
    if current_page?(:action => 'show') && !school_admin.district_guid.present?
      link_to 'Edit School Admin', edit_admin_school_admin_path(school_admin)
    end
  end

  controller do
    def create
      create! do |format|
        format.html { redirect_to admin_school_admin_path @school_admin}
      end
    end
    def update
      if params[:school_admin][:user_attributes][:password].blank?
        params[:school_admin][:user_attributes].delete(:password)
        params[:school_admin][:user_attributes].delete(:password_confirmation)
      end
      if resource.status != "inactive" && params[:school_admin][:status] == "inactive"
        resource.audit_logs.create(person_id: current_person.id)       
      end  
      update! do |format|
        format.html { redirect_to admin_school_admins_path }
      end
    end
  end
end
