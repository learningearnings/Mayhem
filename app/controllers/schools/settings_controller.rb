class Schools::SettingsController < SchoolAdmins::BaseController
  def show
    @teachers = current_school.teachers.order(:first_name, :last_name)
    @distributing_teachers = current_school.distributing_teachers
    @school = current_school
    @sponsor_post = current_school.sponsor_post
  end

  def index
    @school = current_school
  end

  def update
    current_school.update_attributes(params[:school])
    redirect_to school_credit_settings_path
  end

  def update_sponsors_text
    sponsor_post = current_school.sponsor_post
    sponsor_post.body = params[:our_sponsor_post][:body]
    sponsor_post.person = current_person
    sponsor_post.published_by = current_person
    if sponsor_post.save
      flash[:notice] = "Sponsor section updated successfully."
    else
      flash[:notice] = "Could not update sponsor section."
    end
    redirect_to '/schools/settings/#tab_edit-sponsors-text'
  end

  def toggle_revoke_credits
    current_school.update_attributes(:can_revoke_credits => params[:school][:can_revoke_credits])
    redirect_to school_settings_path
  end

  def toggle_distributor
    reward_teachers = Teacher.find(params[:reward_teachers]) if params[:reward_teachers]
    credit_teachers = Teacher.find(params[:credit_teachers]) if params[:credit_teachers]
    if reward_teachers.present?
      reward_teachers.each do |teacher|
        psl = teacher.person_school_links.where(:school_id => current_school.id).first
        if teacher.can_distribute_rewards? current_school
          RewardDistributor.where(:person_school_link_id => psl.id).delete_all
        else
          rd = RewardDistributor.create(:person_school_link_id => psl.id)
        end
      end
    end
    if credit_teachers.present?
      credit_teachers.each do |teacher|
        if teacher.can_distribute_credits
          teacher.update_attribute(:can_distribute_credits, false)
        else
          teacher.update_attribute(:can_distribute_credits, true)
        end
      end
    end
    redirect_to :back
  end

  def import_teachers
    begin
      importer = TeachersImporter.new(params[:school_id], params[:file])
      importer.call
      flash[:notice] = "Teachers import complete."
    rescue Exception => e
      flash[:error] = "Teachers import Failed. Error: #{e.message}"
    ensure
      redirect_to '/schools/settings/#tab_import-teachers'
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
