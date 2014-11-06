class Schools::SettingsController < SchoolAdmins::BaseController
  def show
    @teachers = current_school.teachers.order(:first_name, :last_name)
    @distributing_teachers = current_school.distributing_teachers
    @school = current_school
  end

  def index
    @school = current_school
  end

  def update
    current_school.update_attributes(params[:school])
    redirect_to school_credit_settings_path
  end

  def toggle_revoke_credits
    current_school.update_attributes(:can_revoke_credits => params[:school][:can_revoke_credits])
    redirect_to school_settings_path
  end

  # TODO: Refactor
  def update_setting
    value = params["value"] == "true" ? true : false
    person = Person.find(params["person-id"])
    person_school_link = PersonSchoolLink.where(person_id: person.id, school_id: current_school.id).first
    if params["setting"] == "can_distribute_credits"
      person.update_attribute(:can_distribute_credits, value)
    elsif params["setting"] == "can_distribute_rewards"
      if value
        RewardDistributor.create(person_school_link_id: person_school_link.id)
      else
        RewardDistributor.where(person_school_link_id: person_school_link.id).delete_all
      end
    elsif params["setting"] == "ignore_teacher"
      if value
        PersonSchoolLinkIgnorer.new(person_school_link.id).execute!
      else
        PersonSchoolLinkUnignorer.new(person_school_link.id).execute!
      end
    else
      # Handle Failure
    end

    render json: { status: 200 }
  end

  def import_teachers
    begin
      importer = TeachersImporter.new(params[:school_id], params[:file])
      importer.call
      flash[:notice] = "Teachers import complete."
    rescue Exception => e
      flash[:error] = "Teachers import Failed. Error: #{e.message}"
    ensure
      redirect_to '/schools/settings/'
    end
  end

  private
  def distributor_list
    @teachers = current_school.teachers.order(:last_name)
    @distributing_teachers = current_school.distributing_teachers
    respond_to do |format|
      format.js do
        render :partial => 'distributor_list', :locals => {:distributing_teachers => @distributing_teachers, :teachers => @teachers,  :last_changed_id => @last_changed_id } do |page|
          page.replace_html('distributor-list')
        end
      end
    end
#    render :partial => 'distributor_list', :locals => {:distributing_teachers => @distributing_teachers,:non_distributing_teachers => @non_distributing_teachers  }
  end

end
