ActiveAdmin.register Student do

#  filter :first_name_or_last_name, :as => :string
  filter :first_name
  filter :last_name
  filter :status, :as => :check_boxes, :collection => proc { Teacher.new().status_paths.to_states.each do |s| s.to_s end }
  filter :grade, :as => :check_boxes, :collection => School::GRADE_NAMES
  filter :gender, :as => :check_boxes, :collection => ['Male','Female']
  filter :created_at, :as => :date_range

  form :partial => "form"

  show do
    @student = Student.find(params[:id])
    render 'school_list'
  end

  controller do
    skip_before_filter :add_current_store_id_to_params
    def update
      @student = Student.find(params[:id])
      @school = School.find_by_name(params[:school])
      PersonSchoolLink.create(:person_id => @student.id, :school_id => @school.id)
      redirect_to admin_student_path(@student)
    end

    def create
      @school = School.find_by_name(params[:school])
      @student = Student.new(params[:student])
      if @student.save
        PersonSchoolLink.create(:person_id => @student.id, :school_id => @school.id)
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
