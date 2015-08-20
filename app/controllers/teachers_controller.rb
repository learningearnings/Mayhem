class TeachersController < ApplicationController
  skip_before_filter :subdomain_required

  def new
    @teacher_signup_form = TeacherSignupForm.new
  end

  def create
    setup_fake_data
    @teacher_signup_form = TeacherSignupForm.new(params[:teacher])
    if @teacher_signup_form.save
      request.env["devise.skip_trackable"] = true
      sign_in(@teacher_signup_form.person.user)
      session[:current_school_id] = @teacher_signup_form.school.id
      UserMailer.delay.teacher_self_signup_email(@teacher_signup_form.person)
      flash[:notice] = 'Thank you for signing up!'
      MixPanelIdentifierWorker.perform_async(@teacher_signup_form.person.user.id, mixpanel_options)              
      MixPanelTrackerWorker.perform_async(@teacher_signup_form.person.user.id, 'Teacher Sign Up', mixpanel_options)
      track_signup_interaction(@teacher_signup_form)
      redirect_to '/'
    else
      render :new
    end
  end

  def approve_teacher
    @teacher = Teacher.find(params[:id])
    @teacher.activate
    UserMailer.teacher_approval_email(@teacher).deliver
    flash[:notice] = "Teacher account activated."
    redirect_to '/'
  end

  def deny_teacher
    @teacher = Teacher.find(params[:id])
    unless @teacher.active?
      UserMailer.teacher_deny_email(@teacher).deliver
      @teacher.user.destroy
      @teacher.destroy
      flash[:notice] = "Teacher account denied."
    else
      flash[:error] = "Teacher account already active."
    end
    redirect_to '/'
  end

  def silent_teacher_deny
    unless @teacher.active?
      @teacher = Teacher.find(params[:id])
      @teacher.user.destroy
      @teacher.destroy
      flash[:notice] = "Teacher account silently denied."
    else
      flash[:error] = "Teacher account already active."
    end
    redirect_to '/'
  end

  private
  
  def track_signup_interaction(signup_form)
    start_time = Time.now
    interaction = Interaction.new ip_address: request.ip
    interaction.person = signup_form.person
    interaction.school_id = signup_form.school.id
    end_time = Time.now
    interaction.elapsed_milliseconds = (end_time - start_time) * 1_000
    interaction.page = "teachers/signup"
    interaction.save
  end
  
  def setup_fake_data
    params[:teacher][:grade] = 5
    params[:teacher][:address1] = "Fake Address"
    params[:teacher][:zip] = 12345
  end
end
