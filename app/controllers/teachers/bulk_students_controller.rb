module Teachers
  class BulkStudentsController < Teachers::BaseController
    before_filter :load_edit, only: [:edit, :update]

    def show
    end

    def new
    end

    def edit
    end

    def import_students
      begin
        importer = StudentsImporter.new(params[:school_id], params[:file])
        importer.call
        flash[:notice] = 'Students have been submitted.'
      rescue Exception => e
        flash[:error] = "Students import failed. Error #{e.message}"
      ensure
        redirect_to teachers_bulk_students_path
      end
    end

    def update
      updater_method = params["form_action_hidden_tag"] == "Delete these students" ? :delete! : :call
      delayed_report = DelayedReport.create(person_id: current_person.id)
      StudentUpdaterWorker.perform_async(params["students"], current_school.id, updater_method, delayed_report.id)
      
      respond_to do |format|
        format.json { render json: { delayed_report_id: delayed_report.id } }
      end
    end

    def create
      @batch_student_creator = BatchStudentCreator.new(params["students"], current_school)
      if @batch_student_creator.call
        flash[:notice] = "Students Created!"
        MixPanelTrackerWorker.perform_async(current_user.id, 'Add Students', mixpanel_options)
        redirect_to action: :show
      else
        flash[:error] = "Error creating students"
        render action: :new
      end
    end

    def manage_parents
      @student = Student.find(params[:student_id])
      @active_tab = params[:action_type] == "generate_code" ? "tab-2" : "tab-1"
      if params[:student]
        @student.update_attributes(params[:student])
      elsif @student.parents.empty? && params[:student].nil?
        @parents = @student.parents.build
        @user = @parents.build_user
      end 
      if params[:action_type]
        @student.set_parent_code
        @student.save
      end 
      respond_to do |format|
        format.html { render partial: 'manage_parents', layout: false,  locals: { student: @student, active_tab: @active_type }}
        format.js 
      end
    end

    def print_parent_code
      student = Student.find(params[:student_id])
      respond_to do |format|
        format.pdf {
          html = render_to_string("_print_parent_code",:formats => [:html], layout: false , locals: { student: student })
          Rails.logger.debug(html.inspect)
          kit = PDFKit.new(html)
          send_data(kit.to_pdf, :filename => "LE_parent_code_#{student.id}.pdf", :type => 'application/pdf', :disposition => 'attachment')
        }
      end     
    end

    protected
    def load_edit
      @actions = [
        "Update Passwords to this Password",
        "Update Passwords = Usernames",
        "Update Passwords as Indicated",
        "Add to Classroom I select:",
        "Edit Student Information"
      ]

      # FIXME: This needs to be dealt with in a better manner
      @actions.push("Delete these students") unless current_person.synced?
      if params[:sort]
        @students = current_school.students.includes(:user).order(params[:sort])
      else
        @students = current_school.students.includes(:user).order(:last_name, :first_name)
      end

      if params[:classroom].present?
        classroom = Classroom.find(params[:classroom])
        @students = classroom.students
      end

      if params[:gender].present?
        @students = @students.for_gender(params[:gender])
      end

      @students = @students.for_grade(params[:grade]) if params[:grade].present?
    end
    
    def parent_school(student)
      student.parents.each do |parent|
        if !parent.school.present?
          psl = PersonSchoolLink.find_or_create_by_person_id_and_school_id(parent.id, student.school.id)
        end  
      end
    end
  end
end
