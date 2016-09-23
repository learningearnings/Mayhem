require 'common_person_config'
ActiveAdmin.register Student do
  include CommonPersonConfig
  menu :parent => "Schools", :priority => 3
  config.action_items.delete_if { |item| item.display_on?(:show) }

  action_item do
    if current_page?(:action => 'show') && !student.district_guid.present?
      link_to 'Edit Student', edit_resource_path(resource)
    end
  end

  controller do
    def create
      create! do |format|
        format.html { redirect_to resource_path(resource) }
      end
    end

    def update
      if params[:student][:user_attributes][:password].blank?
        params[:student][:user_attributes].delete(:password)
        params[:student][:user_attributes].delete(:password_confirmation)
      end
      if resource.status != "inactive" && params[:student][:status] == "inactive"
        resource.audit_logs.create(person_id: current_person.id)       
      end  
      super
    end
  end
end
