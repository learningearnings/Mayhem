ActiveAdmin.register Teacher do

  filter :first_name_or_last_name, :as => :string
  filter :last_name
  filter :schools_name_contains
  filter :status, :as => :check_boxes, :collection => proc { Teacher.new().status_paths.to_states.each do |s| s.to_s end }
  filter :grade, :as => :check_boxes, :collection => School::GRADE_NAMES
  filter :created_at, :as => :date_range

  form :partial => "form"

  show do
    @teacher = Teacher.find(params[:id])
    render 'school_list'
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
