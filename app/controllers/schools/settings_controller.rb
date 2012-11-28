class Schools::SettingsController < SchoolAdmins::BaseController
  layout 'resp_application'
  def show
    @teachers = current_school.teachers.all
    @distributing_teachers = current_school.distributing_teachers
    @last_changed_id = 0
  end

  def toggle_distributor
    teacher = Teacher.find(params[:teacher_id])
    psl = teacher.person_school_links.where(:school_id => current_school.id).first
    if teacher.can_distribute_rewards? current_school
      RewardDistributor.where(:person_school_link_id => psl.id).each do |rd|
        rd.destroy
      end
    else
      rd = RewardDistributor.create(:person_school_link_id => psl.id)
    end
    @last_changed_id = params[:teacher_id]
    distributor_list
  end


  private
  def distributor_list
    @teachers = current_school.teachers.all
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
