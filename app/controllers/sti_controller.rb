load 'lib/sti/client.rb'
class StiController < ApplicationController
  include Mixins::Banks
  helper_method :current_school, :current_person
  http_basic_authenticate_with name: "LearningEarnings", password: "ao760!#ACK^*1003rzQa", except: [:give_credits, :create_ebucks_for_students, :new_school_for_credits, :save_school_for_credits]
  skip_around_filter :track_interaction
  skip_before_filter :subdomain_required
  before_filter :handle_sti_token, :only => [:give_credits, :create_ebucks_for_students]

  def give_credits
    if current_school.credits_scope != "School-Wide"
      @child = School.where(sti_id: current_school.id, credits_type: "child")
      if @child.size == 0
        redirect_to :action => "new_school_for_credits", :teacher => @teacher.id and return 
      else       
        @current_school = @child[0]        
        session[:current_school_id] = @child[0].id
        @teacher = @current_school.teachers.first
        @current_person = @teacher
        sign_in(@teacher.user)
        if params["studentIds"]
          @students = current_school.students.where(sti_id: params["studentIds"].split(",")).order(:last_name, :first_name)
        else
          @students = current_school.students.order(:last_name, :first_name)          
        end
      end
    else
      load_students  
    end  
    render :layout => false
  end
  
  def new_school_for_credits
    @teacher = Teacher.find(params[:teacher])
    @school = current_school
    @new_school_form = NewSchoolForm.new
    render :layout => false
  end
  
  def save_school_for_credits
    @teacher = Teacher.find(params[:school][:teacher])
    @new_school_form = NewSchoolForm.new(params[:school])
    if @new_school_form.save(current_school,@teacher)
      @current_school = @new_school_form.school  
      @current_person = @new_school_form.teacher    
      request.env["devise.skip_trackable"] = true
      sign_in(@new_school_form.teacher.user)      
      session[:current_school_id] = @current_school.id
      @students = []
      if params["studentIds"]
        @students = current_school.students.where(sti_id: params["studentIds"].split(",")).order(:last_name, :first_name)
      else
        @students = current_school.students.order(:last_name, :first_name)
      end
      
      @host_ar =  request.host_with_port.split(".")  
      if @host_ar.size == 3
        @le_link = "#{current_school.store_subdomain}.#{@host_ar[1]}.#{@host_ar[2]}/begin_tour"
      else
        @le_link = "#{current_school.store_subdomain}.#{@host_ar[0]}.#{@host_ar[1]}/begin_tour"        
      end
      render :layout => false
    else
      render :new_school_for_credits
    end
  end

  def sync
    @link = StiLinkToken.where(district_guid: params[:district_guid]).first
    if @link
      if StiImporterWorker.setup_sync(@link.api_url, @link.username, @link.password, @link.district_guid)
        render :json => {:status => :success}
      else
        render :json => {:status => :success, :message => "Job was already queued"}
      end
    else
      render :json => {:status => :failure}
    end
  end

  def link
    if params[:district_guid].blank? || params[:api_url].blank? || params[:link_key].blank? || params[:inow_username].blank?
      render :status => 400, :json => {:status => :failure, :message => "You must provide a district_guid, api_url, inow_username, and link_key"} and return
    end
    @link = StiLinkToken.where(district_guid: params[:district_guid]).first
    password = params[:inow_password].blank? ? @link.try(:password) : params[:inow_password]
    if @link && @link.api_url != params[:api_url]
      render :status => 400, :json => {:status => :failure, :message => "The api url doesn't match that district_guid record"} and return
    end
    link_status = check_link_status(params[:api_url], params[:link_key], params[:inow_username], password)
    render :status => 400, :json => {:status => :failure, :message => "The link endpoint returned: #{link_status}"} and return unless link_status.parsed_response == "active"
    if @link && @link.api_url == params[:api_url]
      @link.update_attribute(:password, params[:inow_password]) unless params[:inow_password].blank?
      render :json => {:status => :success, :message => "Your information matched our records and the link was active"} and return
    else
      @link = StiLinkToken.create(district_guid: params[:district_guid], api_url: params[:api_url], link_key: params[:link_key], username: params[:inow_username], password: params[:inow_password])
      StiImporterWorker.setup_sync(@link.api_url, @link.username, @link.password, @link.district_guid)
      render :json => {:status => :success, :message => "The Sync record was created"} and return
    end
  end

  private
  def check_link_status url, link_key, username, password
    begin
      sti_client = STI::Client.new(:base_url => url, :username => username, :password => password)
      link_status = sti_client.link_status(link_key)
    rescue
      return "Connection failed"
    end
    link_status
  end

  def load_students
    @students = current_school.students.where(district_guid: params[:districtGUID], sti_id: params["studentIds"].split(",")).order(:last_name, :first_name)
  end

  def on_success(obj = nil)
    flash[:notice] = 'Credits sent!'
    redirect_to :back
  end

  def on_failure
    flash[:error] = 'You do not have enough credits.'
    redirect_to :back
  end

  def person
    current_person
  end

  def login_teacher
    @teacher = Teacher.where(district_guid: params[:districtGUID], sti_id: @client_response["StaffId"]).first
    return false if @teacher.nil?
    school = @teacher.schools.where(district_guid: params[:districtGUID]).first
    sign_in(@teacher.user)
    #session[:current_school_id] = school.id
    # Current workaround for loading up the correct school
    #  This is based off of looking up the school that a
    #  student is associated with
    student_sti_id = params["studentIds"].split(",").first if params["studentIds"].present?
    if student_sti_id.present?
      student = Student.where(district_guid: params[:districtGUID], sti_id: student_sti_id).first
      # Use the latest school the student was linked with
      #  this fixes yet another bug where a student can be
      #  associated to multiple schools, even though they are
      #  only suppose to be associated to 1.
      session[:current_school_id] = student.person_school_links.order('created_at desc').first.school_id
    else
      # This is left in, just so the iFrame doesn't break if there are no studentIds
      session[:current_school_id] = school.id
    end
    return true
  end

  def handle_sti_token
    #if current_person
    #  @teacher = current_person
    #  return
    #end
    sti_link_token = StiLinkToken.where(:district_guid => params[:districtGUID]).last
    sti_client = STI::Client.new :base_url => sti_link_token.api_url, :username => sti_link_token.username, :password => sti_link_token.password
    sti_client.session_token = params["sti_session_variable"]
    @client_response = sti_client.session_information.parsed_response
    if @client_response["StaffId"].blank? || !login_teacher
      render partial: "teacher_not_found"
    end
  end
end
