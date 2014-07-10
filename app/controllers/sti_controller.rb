load 'lib/sti/client.rb'
class StiController < ApplicationController
  include Mixins::Banks
  helper_method :current_school, :current_person
  http_basic_authenticate_with name: "LearningEarnings", password: "ao760!#ACK^*1003rzQa", except: [:give_credits, :create_ebucks_for_students]
  skip_around_filter :track_interaction
  skip_before_filter :subdomain_required
  skip_before_filter :verify_authenticity_token
  before_filter :handle_sti_token, :only => [:give_credits, :create_ebucks_for_students]

  def give_credits
    if @client_response["StaffId"].blank? || !login_teacher
      render partial: "teacher_not_found"
    else
      load_students
      render :layout => false
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
    teacher = Teacher.where(district_guid: params[:districtGUID], sti_id: @client_response["StaffId"]).first
    return false if teacher.nil?
    school = teacher.schools.where(district_guid: params[:districtGUID]).first
    session["warden.user.user.session"] = {"last_request_at" => Time.now.to_s}
    session["warden.user.user.key"] = ["Spree::User", [teacher.user.id], nil]
    session["current_school_id"] = school.id
    return true
  end

  def handle_sti_token
    sti_link_token = StiLinkToken.where(:district_guid => params[:districtGUID]).last
    sti_client = STI::Client.new :base_url => sti_link_token.api_url, :username => sti_link_token.username, :password => sti_link_token.password
    sti_client.session_token = params["sti_session_variable"]
    Rails.logger.warn "***************************************************"
    Rails.logger.warn sti_client.session_information.parsed_response
    Rails.logger.warn "***************************************************"
    Rails.logger.warn "***************************************************"
    Rails.logger.warn "***************************************************"
    Rails.logger.warn "***************************************************"
    Rails.logger.warn "***************************************************"
    Rails.logger.warn "***************************************************"
    @client_response = sti_client.session_information.parsed_response
  end
end
