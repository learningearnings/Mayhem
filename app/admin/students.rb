require 'common_person_config'
ActiveAdmin.register Student do
  include CommonPersonConfig
  menu :parent => "Schools", :priority => 3
  #config.action_items.delete_if { |item| binding.pry; item.display_on?(:show) }
  config.action_items.delete_if { |item| item.display_on?(:show) }

  action_item do
    if current_page?(:action => 'show') && !student.district_guid.present?
      link_to 'Edit Student', edit_resource_path(resource)
    end
  end
  action_item do
    if current_page?(:action => 'show') && !student.district_guid.present?
      link_to "Delete Student", resource_path(resource), :confirm => 'Are you sure?', :method => :delete
    end
  end

  controller do
    def create
      create! do |format|
        format.html { redirect_to admin_student_path(resource) }
      end
    end
  end
end
