require 'common_person_config'
ActiveAdmin.register Teacher do
  include CommonPersonConfig
  menu :parent => "Schools", :priority => 1

  config.action_items.delete_if { |item| item.display_on?(:show) }

  action_item do
    if current_page?(:action => 'show') && !teacher.district_guid.present?
      link_to 'Edit Teacher', edit_resource_path(resource)
    end
  end
  action_item do
    if current_page?(:action => 'show') && !teacher.district_guid.present?
      link_to "Delete Teacher", resource_path(resource), :confirm => 'Are you sure?', :method => :delete
    end
  end

  controller do
    def create
      create! do |format|
        format.html { redirect_to resource_path(resource) }
      end
    end

    def update
      if params[:teacher][:user_attributes][:password].blank?
        params[:teacher][:user_attributes].delete(:password)
        params[:teacher][:user_attributes].delete(:password_confirmation)
      end
      if resource.status != "inactive" && params[:teacher][:status] == "inactive"
        resource.audit_logs.create(person_id: current_person.id)       
      end  
      super
    end
  end

end
