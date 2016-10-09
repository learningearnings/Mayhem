load 'lib/sti/client.rb'
class StiController < ApplicationController
  include Mixins::Banks
  helper_method :current_school, :current_person
  http_basic_authenticate_with name: "LearningEarnings", password: "ao760!#ACK^*1003rzQa", except: [:auth, :save_teacher, :link, :give_credits, :create_ebucks_for_students, :new_school_for_credits, :save_school_for_credits, :begin_le_tour]
  skip_around_filter :track_interaction
  skip_before_filter :subdomain_required
  skip_before_filter :verify_authenticity_token
  before_filter :handle_sti_token, :only => [:give_credits, :create_ebucks_for_students]
  
  def sync_district
    @district = District.where(guid: params[:district_guid]).first if params[:district]
    @district = District.where(guid: School.find(params[:school_id]).district_guid).first if params[:school_id]
    @district.current_student_version = nil
    @district.current_staff_version = nil
    @district.current_roster_version = nil
    @district.current_section_version = nil
    @district.save
    sti_link_token = StiLinkToken.where(district_guid: @district.guid).last
    client = STI::Client.new(base_url: sti_link_token.api_url, username: sti_link_token.username, password: sti_link_token.password)
    StiImporterWorker.new.perform(sti_link_token.api_url, "LearningEarnings",sti_link_token.password, @district.guid)
    render :text => "Sync job submitted, check Sync Attempts for completion status"
  end

  def give_credits
    if current_school == nil or current_person == nil or current_person.main_account(current_school) == nil
      redirect_to main_app.page_path('home') and return
    end
    if current_school.credits_scope != "School-Wide" 
      if current_school.credits_type != "child"
        redirect_to :action => "new_school_for_credits", :teacher => @teacher.id, :school => current_school.id and return 
      else
        if params["studentIds"]
          @students = @current_school.students.where(sti_id: params["studentIds"].split(",")).order(:last_name, :first_name)
        else
          @students = @current_school.students.order(:last_name, :first_name)          
        end
      end
    else     
      load_students  
    end  
    @teacher_email_form = TeacherEmailForm.new(:person_id => current_person.id)
    begin
      start_time = Time.now
      interaction = Interaction.new ip_address: request.ip
      interaction.person = current_person if current_person
      interaction.school_id = session[:current_school_id]
      end_time = Time.now
      interaction.elapsed_milliseconds = (end_time - start_time) * 1_000
      interaction.page = "/sti/give_credits"
      interaction.save
    rescue
    end
    render :layout => false
  end
  
  def auth
    Rails.logger.info("AKT: Enter auth with params: #{params.inspect}")
    if params["sti_session_variable"]
      #integrated
      sti_link_token = StiLinkToken.where(:district_guid => params[:districtGUID], status: 'active').last
      if (sti_link_token == nil)
        flash[:error] = "Integrated sign in failed for district GUID #{params[:districtGUID]}; sti link token not found"
        return
      end    
      sti_client = STI::Client.new :base_url => sti_link_token.api_url, :username => sti_link_token.username, :password => sti_link_token.password
      sti_client.session_token = params["sti_session_variable"]
      @client_response = sti_client.session_information.parsed_response
      Rails.logger.info("AKT Client response: #{@client_response.inspect}")
      if @client_response == nil or  ( @client_response["StaffId"].blank? and @client_response["StudentId"].blank? )
        flash[:error] = "Integrated sign in failed for district GUID #{params[:districtGUID]}; sti link client bad response"
        return
      end  
      if @client_response["StaffId"].blank?
        @student = Student.where(district_guid: params[:districtGUID], sti_id: @client_response["StudentId"], status: "active").first
        if login_student
          if current_school
            redirect_to "/" and return
          else
            Rails.logger.error("AKT Integrated sign in failed for district GUID, No school for logged in student")
            flash[:error] = "Integrated sign in failed for district GUID, No school for logged in student"        
            redirect_to "#{request.protocol}#{request.env["HTTP_HOST"]}" and return          
          end   
        else
          Rails.logger.error("AKT Integrated sign in failed for district GUID, Student login failed")        
          flash[:error] = "Integrated sign in failed for district GUID #{params[:districtGUID]}, "  
          return               
        end
      end
      @teacher = Teacher.where(district_guid: params[:districtGUID], sti_id: @client_response["StaffId"], status: "active").first   
      @schools = @teacher.schools.where(district_guid: params[:districtGUID], status: "active")
      if @schools and @schools.size > 1 and params[:sti_school_id].blank? and params[:schoolId].blank?
        render partial: "teacher_choose_school", :locals => {:schools => @schools}        
        return         
      end    
      if login_teacher
        if current_school
          redirect_to main_app.teachers_home_path and return
        else
          Rails.logger.error("AKT Integrated sign in failed for district GUID, No school for logged in teacher")
          flash[:error] = "Integrated sign in failed for district GUID, No school for logged in teacher"        
          redirect_to "#{request.protocol}#{request.env["HTTP_HOST"]}" and return          
        end
      else
        Rails.logger.error("AKT Integrated sign in failed for district GUID, Teacher login failed")        
        flash[:error] = "Integrated sign in failed for district GUID #{params[:districtGUID]}, "
      end
    else 
      if params[:schoolId].blank? and params[:sti_school_id].blank?
        flash[:error] = "Non integrated sign in failed -- Missing required parameter schoolId"
        return
      end
      if params[:districtGUID].blank?
        flash[:error] = "Non integrated sign in failed -- Missing required parameter districtGUID"
        return
      end
      if params[:schoolId].blank?      
        school = School.where(:district_guid => params[:districtGUID], :sti_id => params[:sti_school_id]).first 
      else
        school = School.where(:district_guid => params[:districtGUID], :sti_id => params[:schoolid]).first        
      end
      if !school
        flash[:error] = "School not found"
        redirect_to main_app.page_path('home') and return        
      end 
      session[:current_school_id] = school.id      
      if params[:userid]
        teacher = school.teachers.detect { | teach | teach.sti_id == params[:userid].to_i }
        if teacher
          if teacher.user.confirmed_at.nil?
            teacher.user.confirmed_at = Time.now
            teacher.user.save
          end          
          sign_in(teacher.user)
          redirect_to "/" and return
        end
        student = school.students.detect { | stu | stu.sti_id == params[:userid].to_i }
        if student
          if student.user.confirmed_at.nil?
            teacher.user.confirmed_at = Time.now
            teacher.user.save
          end          
          sign_in(student.user)
          redirect_to "/" and return
        end    
        flash[:error] = "User not found"    
        redirect_to main_app.page_path('home') and return   
      else
        flash[:error] = "Non integrated sign in failed -- Missing required parameters"
      end
    end
  end
  
  def save_teacher
    @teacher_email_form = TeacherEmailForm.new(params[:teacher])
    @teacher_email_form.save
    redirect_to :action => :give_credits
  end 
    
  def new_school_for_credits
    @teacher = Teacher.find(params[:teacher])
    @school = School.find(params[:school])
    @new_school_form = NewSchoolForm.new
    render :layout => false
  end
  
  def save_school_for_credits
    @teacher = Teacher.find(params[:school][:teacher])
    @school = School.find(params[:school][:school])
    @new_school_form = NewSchoolForm.new(params[:school])
    if @new_school_form.save(@school,@teacher)
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
      @le_link = "/sti/begin_le_tour?sid=#{@current_school.id}"
      render :layout => false
    else
      render :new_school_for_credits
    end
  end
  
  def begin_le_tour
    @current_school = School.find(params[:sid])
    @current_person = @current_school.teachers.first
    sign_in(@current_person.user)    
    session[:current_school_id] = @current_school.id 
    session[:tour] = "Y"    
    redirect_to "/?tour=Y"  
  end 
  
  def sync
    @link = StiLinkToken.where(district_guid: params[:district_guid], status: 'active').first
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
    @link = StiLinkToken.where(district_guid: params[:district_guid], status: 'active').first
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
      @link = StiLinkToken.create(district_guid: params[:district_guid], api_url: params[:api_url], link_key: params[:link_key], username: params[:inow_username], password: params[:inow_password], status: 'active')
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
    if params["studentIds"]
      @students = current_school.students.where(district_guid: params[:districtGUID], sti_id: params["studentIds"].split(",")).order(:last_name, :first_name)
    else
      @students = current_school.students.where(district_guid: params[:districtGUID]).order(:last_name, :first_name)      
    end
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
  
  def login_student
    Rails.logger.info("AKT Login student: #{@client_response["StudentId"]}, district_guid: #{params[:districtGUID]}, sti_school_id: #{params[:sti_school_id]}, schoolId: #{params[:schoolId]}")
    @student = Student.where(district_guid: params[:districtGUID], sti_id: @client_response["StudentId"], status: "active").first
    Rails.logger.info("AKT Login student: #{@student.inspect}")
    return false if @student.nil?   
    if params[:sti_school_id]
      school = School.where(district_guid: params[:districtGUID], sti_id: params[:sti_school_id], status: "active").first
    elsif params[:schoolId]
      school = School.where(district_guid: params[:districtGUID], sti_id: params[:schoolId], status: "active").first
    else
      sid = @student.person_school_links.order('created_at desc').first.try(:school_id)
      school = School.where(id: sid).first if sid  
    end  
    if school
      session[:current_school_id] = school.id
      school = school
      @current_school = school 
    else
      Rails.logger.error("AKT Login student, no school found")
      return false    
    end   
    Rails.logger.info("AKT Login school: #{school.inspect}")
    if @student.user.confirmed_at.nil?
      @student.user.confirmed_at = Time.now
      @student.user.save
    end
    sign_in(@student.user)  
    Rails.logger.info("AKT: Student signed in..")
    return true  
  end

  def login_teacher
    Rails.logger.info("AKT Login teacher: #{@client_response["StaffId"]}, district_guid: #{params[:districtGUID]}, sti_school_id: #{params[:sti_school_id]}, schoolId: #{params[:schoolId]}")
    @teacher = Teacher.where(district_guid: params[:districtGUID], sti_id: @client_response["StaffId"], status: "active").first
    Rails.logger.info("AKT Login teacher: #{@teacher.inspect}")
    return false if @teacher.nil?
    if params[:sti_school_id]
      school = @teacher.schools.where(district_guid: params[:districtGUID], sti_id: params[:sti_school_id], status: "active").first
    elsif params[:schoolId]
      school = @teacher.schools.where(district_guid: params[:districtGUID], sti_id: params[:schoolId], status: "active").first
    else
      school = @teacher.schools.where(district_guid: params[:districtGUID], status: "active").first    
    end
    if school
      session[:current_school_id] = school.id 
      @current_school = school
    end
    Rails.logger.info("AKT Login school: #{school.inspect}")
    if @teacher.user.confirmed_at.nil?
      @teacher.user.confirmed_at = Time.now
      @teacher.user.save
    end
    sign_in(@teacher.user)
    #session[:current_school_id] = school.id
    # Current workaround for loading up the correct school
    #  This is based off of looking up the school that a
    #  student is associated with
    Rails.logger.info("AKT: Teacher signed in..")
    student_sti_id = params["studentIds"].split(",").first if params["studentIds"].present?
    if student_sti_id.present?
      student = Student.where(district_guid: params[:districtGUID], sti_id: student_sti_id).first
      # Use the latest school the student was linked with
      #  this fixes yet another bug where a student can be
      #  associated to multiple schools, even though they are
      #  only suppose to be associated to 1.
      if student
        sid = student.person_school_links.order('created_at desc').first.try(:school_id)
        student_school = School.where(id: sid).first if sid
        if student_school
          session[:current_school_id] = sid
          school = student_school
          @current_school = school     
        end
      else
        Rails.logger.error("AKT Student not found with sti_id #{student_sti_id} for district #{params[:districtGUID]}")
      end
    end
    if school and school.credits_scope != "School-Wide" 
      @child = School.where(sti_id: school.id, credits_type: "child")
      if @child.size > 0
        @current_school = @child[0]        
        @teacher = @current_school.teachers.first
        if @teacher
          session[:current_school_id] = @child[0].id          
          @current_person = @teacher
          sign_in(@teacher.user)  
        else
          Rails.logger.error("AKT: School #{school.id} with credits scope: #{school.credits_scope} has no child, district_guid:  #{params[:districtGUID]}")
          flash[:error] = "School #{school.id} with credits scope: #{school.credits_scope} has no child, district_guid: #{params[:districtGUID]}"         
          return false
        end      
      end   
    end    
    if !school
      Rails.logger.error("AKT Login Teacher, no school found")
      return false
    end    
    return true
  end

  def handle_sti_token
    sti_link_token = StiLinkToken.where(:district_guid => params[:districtGUID], status: 'active').last
    if (sti_link_token == nil)
      return false
    end    
    sti_client = STI::Client.new :base_url => sti_link_token.api_url, :username => sti_link_token.username, :password => sti_link_token.password
    sti_client.session_token = params["sti_session_variable"]
    @client_response = sti_client.session_information.parsed_response
    if @client_response == nil || @client_response["StaffId"].blank? || !login_teacher
      render partial: "teacher_not_found"        
      return false
    end
    return true
  end
end