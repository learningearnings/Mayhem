#
# Hack to Dry up the Active Admin administration of Students, Teachers and SchoolAdmins
# Active Admin supports STI, but apparently didn't support re-using setup code for the
# different classes.   See admin/school_admins.rb, admin/teachers.rb and admin/students.rb
#
# Also see app/views/admin/common/_school_list.html.haml for the partial
#
module CommonPersonConfig

  def self.included(dsl)
    dsl.run_registration_block do

      filter :user_email, :as => :string
      filter :user_username, :as => :string
      filter :first_name_or_last_name, :as => :string
      filter :last_name
      filter :allschools_name,:label => "School Filter", collection: proc { School.status_active.all.collect {|s|s.name}.sort | School.status_inactive.all.collect {|s| s.name + '( inactive )'} } , as: :select
      filter :status,:label => "Status", :as => :check_boxes, :collection => proc { Person.new().status_paths.to_states.each do |s| s.to_s end }
      filter :grade,:label => "Grade", :as => :check_boxes, :collection => School::GRADE_NAMES
      filter :district_guid
      filter :sti_id
      filter :created_at, :as => :date_range

      form do |f|
        f.inputs do
          f.input :first_name
          f.input :last_name
          f.input :dob, :as => :datepicker
          if f.object.is_a?(Student)
            f.input :gender, as: :select, collection: ['Male', 'Female']
          end
          f.input :grade, :as => :select, :collection => School.grades, :wrapper_html => {:class => 'horizontal'}
          f.input :status, :label => "Initial Status", :as => :select, :collection => ['new','active','inactive']

          if f.object.is_a?(Teacher)
            f.input :can_distribute_credits
          end
          if f.object.is_a?(Teacher)
            f.input :type, :label => "Type", :as => :select, :collection => ['SchoolAdmin', 'Teacher']
          end
          f.input :district_guid
          f.input :sti_id
          if f.object.new?
            f.input :username, :required => true
            if !f.object.is_a?(Student)
              f.input :email
            end
            f.input :password
            f.input :password_confirmation
          else
            f.inputs :for => [:user, f.object.user] do |u|
              u.input :username, :required => true
              if !f.object.is_a?(Student)
                u.input :email
              end
              u.input :password
              u.input :password_confirmation
            end
          end
        end
        f.actions
      end

      show do
        @person = Person.find(params[:id])
        render :partial => 'admin/common/school_list', :locals => { :person => @person }
      end

      member_action :give_credits, :method => :post do
        person = Person.find(params[:id])
        amount = params[:credits][:amount]
        #if amount.nil? || amount.to_f <= 0.0
        #  flash[:error] = "Please enter a positive, non-zero amount of credits"
        #  redirect_to :action => :show and return
        #end
        if person.is_a? Teacher
          if person.is_a? SchoolAdmin
            school = School.find(params[:school_admin][:school_id])
          else
            school = School.find(params[:teacher][:school_id])
          end
          if school.nil? || person.nil? or !person.schools.include?(school)
            flash[:error] = "Something went wrong - maybe try that again???"
            redirect_to :action => :show and return
          end
          cm = CreditManager.new
          cm.issue_credits_to_school school, amount
          cm.issue_credits_to_teacher school, person, amount
          flash[:notice] = "Gave $#{amount} credits to Teacher #{person.name} at #{school.name}"
        elsif person.is_a? Student
          cm = CreditManager.new
          cm.issue_admin_credits_to_student person, amount
          flash[:notice] = "Gave $#{amount} credits to Student #{person.name}"
        end
        redirect_to :action => :show
      end

      member_action :add_school, :method => :post do
        person = Person.find(params[:id]) rescue nil
        school = School.find(params[:school_id]) rescue nil
        if person.nil?
          flash[:error] = "Something went wrong - could not find a person - maybe try that again???"
        elsif school.nil?
          flash[:error] = "Please select a school to associate with #{person.name}"
        elsif person.schools.include?(school)
          flash[:error] = "#{person.name} is already associated with #{school.name}"
        else
          @psl = PersonSchoolLink.find_or_create_by_person_id_and_school_id(person_id: person.id, school_id: school.id)
          if @psl.valid?
            flash[:notice] = "Associated #{person.name} with #{school.name}"
          else
            flash[:error] = @psl.errors.messages[:status]
            #flash[:error] = "Username already associated with this school."
          end
        end
        redirect_to :action => :show
      end

      member_action :delete_school, :method => :delete do
        person = Person.find(params[:id])
        school = School.find(params[:school_id])
        link = PersonSchoolLink.find_by_person_id_and_school_id(person.id, school.id)
        if link.delete
          flash[:notice] = "Removed #{person.name} from #{school.name}"
        else
          flash[:error] = "Could NOT remove #{person.name} from #{school.name}"
        end
        #redirect_to admin_person_path(person)
        redirect_to :action => :show and return
      end

      index do
        column :id do |t|
          link_to t.id, [:admin,t]
        end
        column :name do |t|
          link_to t.name, [:admin,t]
        end
        column :schools do |t|
          output = t.schools.collect do |s|
            link_to(s.name, admin_school_path(s))
          end
          output.join("<br />").html_safe
        end
        column :classrooms do |t|
          t.classrooms.count > 0 ? t.classrooms.count : ""
        end
        column :dob do |t|
          t.dob.strftime("%m/%d/%Y") if t.dob
        end
        column :grade
        column :status
        column :gender
        column :salutation
        column "STI district GUID", :district_guid
        column "STI id", :sti_id
        column "Created", :created_at do |t|
          t.created_at.strftime("%m/%d/%Y") if t.created_at
        end
        column "Updated", :updated_at do |t|
          t.updated_at.strftime("%m/%d/%Y") if t.updated_at
        end
        default_actions
        #column :actions do |resource|
        #  links = link_to I18n.t('active_admin.view'), resource_path(resource)
        #  links += ' '
        #  if !resource.district_guid.present?
        #    links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource)
        #    links += ' '
        #  end
        #    links += link_to "Delete", resource_path(resource), :confirm => 'Are you sure?', :method => :delete
        #  links
        #end
      end
      controller do
        skip_before_filter :add_current_store_id_to_params
      end
    end
  end
end

class ActiveAdmin::Views::TableFor
  def build_table_body
    @tbody = tbody do
      # Build enough rows for our collection
      #@collection.each{|_| tr(:class => cycle('odd', 'even'), :id => dom_id(_)) }
      @collection.each do |object|
        if object.is_a? SchoolAdmin
          tr(:class => 'bg-red', :id => dom_id(object))
        else
          tr(:class => cycle('odd', 'even'), :id => dom_id(object))
        end
      end
    end
  end
end
