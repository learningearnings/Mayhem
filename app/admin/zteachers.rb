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
    # if current_page?(:action => 'show') && !teacher.district_guid.present?
    #   link_to "Delete Teacher", admin_inactivate_teacher(resource), :confirm => 'Are you sure?', :method => :delete
    # end
  end

  controller do
    def create
      create! do |format|
        format.html { redirect_to resource_path(resource) }
      end
    end

    def update
      if params[:teacher][:user_attributes] && params[:teacher][:user_attributes][:password].blank?
        params[:teacher][:user_attributes].delete(:password)
        params[:teacher][:user_attributes].delete(:password_confirmation)
      end
      if resource.status != "inactive" && params[:teacher][:status] == "inactive"
        resource.audit_logs.create(district_guid: resource.district_guid, school_id: resource.school.try(:id), school_sti_id: resource.school.try(:sti_id), person_id: current_person.id, person_name: current_person.name, person_type: current_person.type, person_sti_id: current_person.sti_id, log_event_name: resource.name, action: "Deactivate")
      end  
      super
    end
  end

end
