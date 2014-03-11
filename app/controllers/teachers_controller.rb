class TeachersController < ApplicationController
  require 'basic_statuses'

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(params[:teacher])
    if Spree::User.where(:email => params[:teacher][:email]).present?
      flash[:error] = 'Email address already linked with an account.'
      render :new
    elsif @teacher.save
      @teacher.user.update_attributes(:username => params[:teacher][:username], :email => params[:teacher][:email], :password => params[:teacher][:password], :password_confirmation => params[:teacher][:password_confirmation])
      if @teacher.user.valid?
        @teacher.set_awaiting
        PersonSchoolLink.create(:school_id => params[:school_id], :person_id => @teacher.id)
        UserMailer.teacher_request_email(@teacher).deliver
        flash[:message] = 'You will be notified when your account is approved.'
        redirect_to '/'
      end
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
