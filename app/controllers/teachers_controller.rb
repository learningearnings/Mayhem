class TeachersController < ApplicationController

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(params[:teacher])
    if @teacher.save
      PersonSchoolLink.create(:school_id => params[:school_id], :person_id => @teacher.id)
      UserMailer.teacher_request_email(@teacher).deliver
      flash[:message] = 'You will be notified when your account is approved.'
      redirect_to '/'
    else
      flash[:error] = 'There was a problem creating your account.'
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
    unless @teacher.active?
      @teacher = Teacher.find(params[:id])
      @teacher.user.destroy
      @teacher.destroy
      UserMailer.teacher_deny_email(@teacher).deliver
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
