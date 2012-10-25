ActiveAdmin.register Student do

#  filter :first_name_or_last_name, :as => :string
  filter :first_name
  filter :last_name
  filter :allschools_name,:label => "School Filter", collection: proc { School.status_active.all.collect {|s|s.name} | School.status_inactive.all.collect {|s| s.name + '( inactive )'} } , as: :select
  filter :status, :as => :check_boxes, :collection => proc { Teacher.new().status_paths.to_states.each do |s| s.to_s end }
  filter :grade, :as => :check_boxes, :collection => School::GRADE_NAMES
  filter :gender, :as => :check_boxes, :collection => ['Male','Female']
  filter :created_at, :label => "Student Created", :as => :date_range

  form :partial => "form"

  show do
    @student = Student.find(params[:id])
    render 'school_list'
  end

  index do
    column :id do |t|
      link_to t.id, admin_student_path(t)
    end
    column :name do |t|
      link_to t.name, admin_student_path(t)
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
    column :grade
    column :status
    column :gender
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
      @student = Student.find(params[:id])
      @student.school = params[:school_id]
      @student.save
      redirect_to admin_student_path(@student)
    end

    def create
#      @school = School.find_by_name(params[:school])
      @student = Student.new(params[:student])
      if @student.save
        @student.school = params[:student][:school]
        flash[:notice] = 'Student created.'
        redirect_to admin_student_path(@student)
      else
        flash[:error] = 'Student not created.'
        render 'form'
      end
    end

    def delete_school_link
      @student = Student.find(params[:student])
      @school = School.find(params[:school])
      link = PersonSchoolLink.find_by_person_id_and_school_id(@student.id, @school.id)
      if link.delete
        redirect_to admin_student_path(@student)
      else
        render 'show'
      end
    end

    def form
      @student = Student.new(params[:student])
    end
  end

end
