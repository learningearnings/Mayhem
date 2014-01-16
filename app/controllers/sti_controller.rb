load 'lib/sti/client.rb'
class StiController < ApplicationController
  include Mixins::Banks
  helper_method :current_school, :current_person
  http_basic_authenticate_with name: "LearningEarnings", password: "Password", except: [:give_credits, :create_ebucks_for_students]
  skip_around_filter :track_interaction
  before_filter :handle_sti_token, :only => [:give_credits, :create_ebucks_for_students]

  def give_credits
    Rails.logger.warn "**********************************"
    Rails.logger.warn @client_response.inspect
    Rails.logger.warn "**********************************"
    if @client_response["StaffId"].blank? || current_person.nil?
      render partial: "teacher_not_found"
    else
      load_students
      render :layout => false
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
      StiImporterWorker.perform_async(@link.api_url, @link.username, @link.password)
      render :json => {:status => :success, :message => "Your information matched our records and the link was active"} and return
    else
      StiLinkToken.create(district_guid: params[:district_guid], api_url: params[:api_url], link_key: params[:link_key], username: params[:inow_username], password: params[:inow_password])
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
    @students = current_person.schools.first.students.where(sti_id: params["studentIds"].split(","))
  end

  def current_person
    Teacher.where(sti_id: @client_response["StaffId"]).first
  end

  def current_school
    current_person.schools.first
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

  def handle_sti_token
    sti_link_token = StiLinkTokent.where(:district_guid => params[:districtGUID]).last
    sti_client = STI::Client.new :base_url => sti_link_token.api_url, :username => sti_link_token.username, :password => sti_link_token.password
    sti_client.session_token = params["sti_session_variable"]
    @client_response = sti_client.session_information.parsed_response
  end
end
