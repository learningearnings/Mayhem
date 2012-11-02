ActiveAdmin.register SchoolAdmin do


  filter :first_name_or_last_name, :as => :string
  filter :last_name
  filter :allschools_name,:label => "School Filter", collection: proc { School.status_active.all.collect {|s|s.name} | School.status_inactive.all.collect {|s| s.name + '( inactive )'} } , as: :select
  filter :status,:label => "School Admin Status", :as => :check_boxes, :collection => proc { SchoolAdmin.new().status_paths.to_states.each do |s| s.to_s end }
  filter :grade,:label => "SchoolAdmin Grade", :as => :check_boxes, :collection => School::GRADE_NAMES
  filter :created_at, :as => :date_range

#  form :partial => "form"

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :dob
      f.input :grade, :as => :radio, :collection => School::GRADE_NAMES, :wrapper_html => {:class => 'horizontal'}
      f.input :status,:label => "Initial Status", :as => :select, :collection => ['new','active','inactive']
    end
    f.actions
  end

  show do
    @school_admin = SchoolAdmin.find(params[:id])
    render 'school_list'
  end

  member_action :give_credits, :method => :post do
    school_admin = SchoolAdmin.find(params[:id])
    amount = params[:credits][:amount]
    if amount.nil? || amount.to_f <= 0.0
      flash[:error] = "Please enter a positive, non-zero amount of credits"
      redirect_to :action => :show and return
    end
    school = School.find(params[:school_admin][:school_id])
    if school.nil? || school_admin.nil? or !school_admin.schools.include?(school)
      flash[:error] = "Something went wrong - maybe try that again???"
      redirect_to :action => :show and return
    end
    cm = CreditManager.new
    cm.issue_credits_to_school school, amount
    cm.issue_credits_to_teacher school,school_admin, amount
    flash[:notice] = "Gave $#{amount} credits to #{school_admin.name} at #{school.name}"
    redirect_to :action => :show
  end


  member_action :add_school, :method => :post do
    school_admin = SchoolAdmin.find(params[:id]) rescue nil
    school = School.find(params[:school_id]) rescue nil
    if school_admin.nil?
      flash[:error] = "Something went wrong - could not find a School Admin - maybe try that again???"
    elsif school.nil?
      flash[:error] = "Please select a school to associate with #{school_admin.name}"
    elsif school_admin.schools.include?(school)
      flash[:error] = "#{school_admin.name} is already associated wiht #{school.name}"
    else
      PersonSchoolLink.create(:person_id => school_admin.id, :school_id => school.id) if school
      flash[:notice] = "Associated #{school_admin.name} with #{school.name}"
    end
    redirect_to :action => :show
  end

  member_action :delete_school, :method => :delete do
    school_admin = SchoolAdmin.find(params[:id])
    school = School.find(params[:school_id])
    link = PersonSchoolLink.find_by_person_id_and_school_id(school_admin.id, school.id)
    if link.delete
      flash[:notice] = "Removed #{school_admin.name} from #{school.name}"
    else
      flash[:error] = "Could NOT remove #{school_admin.name} from #{school.name}"
    end
    redirect_to admin_school_admin_path(school_admin)

  end



  index do
    column :id do |t|
      link_to t.id, admin_school_admin_path(t)
    end
    column :name do |t|
      link_to t.name, admin_school_admin_path(t)
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
    column "Created", :created_at do |t|
      t.created_at.strftime("%m/%d/%Y") if t.created_at
    end
    column "Updated", :updated_at do |t|
      t.updated_at.strftime("%m/%d/%Y") if t.updated_at
    end
  end


  controller do
    skip_before_filter :add_current_store_id_to_params
  end





=begin
  filter :first_name
  filter :last_name
  filter :status, :as => :check_boxes, :collection => proc { Teacher.new().status_paths.to_states.each do |s| s.to_s end }
  filter :grade, :as => :check_boxes, :collection => School::GRADE_NAMES
  filter :created_at, :as => :date_range

  form :partial => "form"

  show do
    @school_admin = SchoolAdmin.find(params[:id])
    render 'school_list'
  end

  controller do
    skip_before_filter :add_current_store_id_to_params

    def update
      @school_admin = SchoolAdmin.find(params[:id])
      @school = School.find_by_name(params[:school])
      PersonSchoolLink.create(:person_id => @school_admin.id, :school_id => @school.id)
      redirect_to admin_school_admin_path(@school_admin)
    end

    def create
      @school = School.find_by_name(params[:school])
      @school_admin = SchoolAdmin.new(params[:school_admin])
      if @teacher.save
        PersonSchoolLink.create(:person_id => @school_admin.id, :school_id => @school.id)
        flash[:notice] = 'SchoolAdmin created.'
        redirect_to admin_school_admin_path(@school_admin)
      else
        flash[:error] = 'SchoolAdmin not created.'
        render 'form'
      end
    end

    def delete_school_link
      @school_admin = SchoolAdmin.find(params[:school_admin])
      @school = School.find(params[:school])
      link = PersonSchoolLink.find_by_person_id_and_school_id(@school_admin.id, @school.id)
      if link.delete
        redirect_to admin_school_admin_path(@school_admin)
      else
        render 'show'
      end
    end

    def form
      @school_admin = SchoolAdmin.new(params[:school_admin])
    end

  end
=end 
end
