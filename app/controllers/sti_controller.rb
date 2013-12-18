load 'lib/sti/client.rb'
class StiController < ApplicationController
  include Mixins::Banks
  helper_method :current_school, :current_person
  skip_around_filter :track_interaction
  before_filter :handle_sti_token, :only => [:give_credits, :create_ebucks_for_students]
  http_basic_authenticate_with name: "LearningEarnings", password: "Password", except: :give_credits

  def give_credits
    if @client_response["StaffId"].blank? || current_person.nil?
      render partial: "teacher_not_found"
    else
      load_students
      render :layout => false
    end
  end

  def sync
    if params[:district_guid].blank? || params[:api_url].blank? || params[:sync_key].blank?
      render :json => {:status => :failure, :message => "You must provide a district_guid, api_url, and sync_key"} and return
    end
    @sync = StiSyncToken.where(district_guid: params[:district_guid]).first
    if @sync
      if @sync.api_url == params[:api_url]
        render :json => {:status => :success, :message => "Your information matched our records"} and return
      else
        render :json => {:status => :failure, :message => "The api url doesn't match that district_guid record"} and return
      end
    else
      StiSyncToken.create(district_guid: params[:district_guid], api_url: params[:api_url], sync_key: params[:sync_key])
      render :json => {:status => :success, :message => "The Sync record was created"} and return
    end
  end

  private
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
    sti_client = STI::Client.new
    sti_client.session_token = params["sti_session_variable"]
    @client_response = sti_client.session_information.parsed_response
  end
end
