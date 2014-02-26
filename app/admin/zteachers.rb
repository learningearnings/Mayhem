require 'common_person_config'
module Admin
  ActiveAdmin.register Teacher do
    include CommonPersonConfig
    menu :parent => "Schools", :priority => 1

    config.action_items.delete_if { |item| item.display_on?(:show) }
    action_item do
      if current_page?(:action => 'show') && !teacher.district_guid.present?
        link_to 'Edit Teacher', edit_teacher_path(teacher)
      end
    end
    action_item do
      if current_page?(:action => 'show') && !teacher.district_guid.present?
        link_to "Delete Teacher", resource_path(resource), :confirm => 'Are you sure?', :method => :delete
      end
    end


  end

end
