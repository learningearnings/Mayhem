ActiveAdmin.register School do

  config.action_items.delete_if { |item| item.display_on?(:show) }

  action_item do
    if current_page?(:action => 'show') && !school.district_guid.present?
      link_to 'Edit School', edit_admin_school_path(school)
    end
  end
  action_item do
    if current_page?(:action => 'show') && !school.district_guid.present?
      link_to "Delete School", resource_path(resource), :confirm => 'Are you sure?', :method => :delete
    end
  end

  filter :name
  filter :district_guid
  filter :sti_id
  filter :state

  index do
    column :id
    column :avatar do |school|
      image_tag(school.logo.thumb('100x75!').url) if school.logo
    end
    column :name do |school|
      link_to(school.name, admin_school_path(school))
    end
    column :address do |school|
      school.address
    end
    column "Grades" do |school|
      school.min_grade.to_s + ' - ' + school.max_grade.to_s
    end
    column :school_phone
    column :mascot_name
    column :status
    column :timezone
    column "Distribution",:distribution_model
    column :store_subdomain
    column "STI District GUID", :district_guid
    column "STI id", :sti_id
    #default_actions
    column :actions do |resource|
      links = link_to I18n.t('active_admin.view'), resource_path(resource)
      links += ' '
      if !resource.district_guid.present?
        links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource)
        links += ' '
        links += link_to "Delete", resource_path(resource), :confirm => 'Are you sure?', :method => :delete
      end
      links
    end
  end

  form :partial => 'form'

  show do |school|
    school_admins = school.school_admins
    teachers = school.teachers.status_active.order([:last_name, :first_name])
    students = school.students.status_active.order([:last_name, :first_name]).includes(:user)
    render 'school_show', teachers: teachers, students: students, school_admins: school_admins
  end

  controller do
    skip_before_filter :add_current_store_id_to_params

    def get_metrics
      @school = School.find params[:school_id]
      render :partial => "school_metrics"
    end
  end

end
