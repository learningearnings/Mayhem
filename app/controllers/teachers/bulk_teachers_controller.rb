module Teachers
  class BulkTeachersController < Teachers::BaseController
    #before_filter :redirect_for_synced_schools
    before_filter :load_edit, only: [:edit, :update]
    before_filter :load_manage_credit, only: [:manage_credits]
    before_filter :load_teachers, only: [:edit, :update, :manage_credits]

    def show
    end

    def new
    end

    def edit
    end

    def import_teachers
      begin
        importer = TeachersImporter.new(params[:school_id], params[:file])
        importer.call
        flash[:notice] = 'Teachers have been submitted.'
      rescue Exception => e
        flash[:error] = "Teachers import failed. Error #{e.message}"
      ensure
        redirect_to teachers_bulk_teachers_path
      end
    end

    def manage_credits
      respond_to do |format|
        format.html
        format.json
      end
    end

    def update_teacher_credits
      update_action = params[:form_action_hidden_tag]
      begin
        teacher_credit_updater = TeacherCreditUpdater.new(current_school, params[:teachers],params[:credit_qty], update_action)
        teacher_credit_updater.handle_credits_to_teacher()
        flash[:notice] = "Added Teachers Credits Successfully." if update_action == "Add Credits"
        flash[:notice] = "Removed Teachers Credits Successfully." if update_action == "Remove Credits"

      rescue Exception => e
        flash[:error] = "Add/Remove Teachers Credits failed. Error #{e.message}"
      ensure 
        redirect_to manage_credits_teachers_bulk_teachers_path
      end  
    end

    def update
      updater_method = params["form_action_hidden_tag"] == "Delete these teachers" ? :delete! : :call
      ::TeacherUpdaterWorker.perform_async(current_person.user.email, params["teachers"], current_person.schools.first, updater_method)
      flash[:notice] = "Bulk process is running."
      redirect_to action: :show
    end

    def create
      @batch_teacher_creator = BatchTeacherCreator.new(params["teachers"], current_school)
      if @batch_teacher_creator.call
        flash[:notice] = "Teachers Created!"
        redirect_to action: :show
      else
        flash[:error] = "Error creating teachers"
        render action: :new
      end
    end

    protected
    def load_edit
      @actions = [
        "Update Passwords to this Password",
        "Update Passwords = Usernames",
        "Update Passwords as Indicated",
        "Edit Teachers Information",
        "Delete these teachers"
      ]
    end

    def load_manage_credit
      @actions = [
        "Add Credits",
        "Remove Credits"
      ]
    end

    def load_teachers
      @teachers = current_school.teachers
      if params[:gender].present?
        @teachers = @teachers.for_gender(params[:gender])
      end
      @teachers = @teachers.for_grade(params[:grade]) if params[:grade].present?
    end

    def redirect_for_synced_schools
      redirect_to root_path if current_school.synced?
    end
  end
end
