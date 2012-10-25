ActiveAdmin.register Teacher do

  filter :first_name_or_last_name, :as => :string
  filter :last_name
  filter :allschools_name,:label => "School Filter", collection: proc { School.status_active.all.collect {|s|s.name} | School.status_inactive.all.collect {|s| s.name + '( inactive )'} } , as: :select
  filter :status,:label => "Teacher Status", :as => :check_boxes, :collection => proc { Teacher.new().status_paths.to_states.each do |s| s.to_s end }
  filter :grade,:label => "Teacher Grade", :as => :check_boxes, :collection => School::GRADE_NAMES
  filter :created_at, :as => :date_range

  form :partial => "form"

  show do
    @teacher = Teacher.find(params[:id])
    render 'school_list'
  end

  index do
    column :id do |t|
      link_to t.id, admin_teacher_path(t)
    end
    column :name do |t|
      link_to t.name, admin_teacher_path(t)
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

    def update
      @teacher = Teacher.find(params[:id])
      @school = School.find_by_name(params[:school])
      PersonSchoolLink.create(:person_id => @teacher.id, :school_id => @school.id)
      redirect_to admin_teacher_path(@teacher)
    end

    def create
      @school = School.find_by_name(params[:school])
      @teacher = Teacher.new(params[:teacher])
      if @teacher.save
        PersonSchoolLink.create(:person_id => @teacher.id, :school_id => @school.id)
        flash[:notice] = 'Teacher created.'
        redirect_to admin_teacher_path(@teacher)
      else
        flash[:error] = 'Teacher not created.'
        render 'form'
      end
    end

    def delete_school_link
      @teacher = Teacher.find(params[:teacher])
      @school = School.find(params[:school])
      link = PersonSchoolLink.find_by_person_id_and_school_id(@teacher.id, @school.id)
      if link.delete
        redirect_to admin_teacher_path(@teacher)
      else
        render 'show'
      end
    end

    def form
      @teacher = Teacher.new(params[:teacher])
    end

  end
  
end
