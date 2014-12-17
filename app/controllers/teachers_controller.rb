class TeachersController < ApplicationController
  skip_before_filter :subdomain_required

  def new
    @teacher_signup_form = TeacherSignupForm.new
  end

  def create
    @teacher_signup_form = TeacherSignupForm.new(params[:teacher])
    if @teacher_signup_form.save
      sign_in(@teacher_signup_form.person.user)
      session[:current_school_id] = @teacher_signup_form.school.id
      UserMailer.delay.teacher_self_signup_email(@teacher_signup_form.person)
      flash[:notice] = 'Thank you for signing up!'
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
end
