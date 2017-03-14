require 'pathname'
require "openid"
require 'openid/extensions/ax'
require 'openid/extensions/sreg'
require 'openid/extensions/pape'
require 'openid/store/filesystem'

class ConsumerController < ApplicationController
  include Mixins::Banks
  helper_method :current_school, :current_person  
  skip_around_filter :track_interaction
  skip_before_filter :subdomain_required
  skip_before_filter :verify_authenticity_token  

  def start
    begin
      identifier = params[:openid_identifier]
      if identifier.nil?
        flash[:error] = "Enter an OpenID identifier"
        redirect_to "/" and return
      end
      oidreq = consumer.begin(identifier)
    rescue OpenID::OpenIDError => e
      flash[:error] = "Discovery failed for #{identifier}: #{e}"
      redirect_to "/" and return
    end
    # required fields
    ax_req = OpenID::AX::FetchRequest.new
    ax_req.add(OpenID::AX::AttrInfo.new("http://powerschool.com/entity/id", "dcid", true))    
    ax_req.add(OpenID::AX::AttrInfo.new("http://powerschool.com/entity/email", "email", true))
    ax_req.add(OpenID::AX::AttrInfo.new("http://powerschool.com/entity/schoolID", "schoolID", true))
    ax_req.add(OpenID::AX::AttrInfo.new("http://powerschool.com/entity/districtName", "districtName", true))    
    ax_req.add(OpenID::AX::AttrInfo.new("http://powerschool.com/entity/usertype", "usertype", true))

    oidreq.add_extension(ax_req)

    return_to = url_for :action => 'complete', :only_path => false
    realm = "https://#{request.domain}/"
    if oidreq.send_redirect?(realm, return_to, params[:immediate])
      redirect_to oidreq.redirect_url(realm, return_to, params[:immediate])
    else
      render :text => oidreq.html_markup(realm, return_to, params[:immediate], {'id' => 'openid_form'})
    end
  end

  def complete
    current_url = url_for(:action => 'complete', :only_path => false)
    parameters = params.reject{|k,v|request.path_parameters[k]}
    parameters.reject!{|k,v|%w{action controller}.include? k.to_s}
    #Rails.logger.info("AKT: SSO Complete parameters: #{parameters.inspect}")
    oidresp = consumer.complete(parameters, current_url)
    openid = oidresp.display_identifier
    case oidresp.status
    when OpenID::Consumer::FAILURE
      if oidresp.display_identifier
        flash[:error] = ("Verification of #{oidresp.display_identifier}"\
                         " failed: #{oidresp.message}")
      else
        flash[:error] = "Verification failed: #{oidresp.message}"
      end
      render :layout => false and return    
    when OpenID::Consumer::SUCCESS
      ax_resp = OpenID::AX::FetchResponse.from_success_response(oidresp)
      @data = ax_resp.data
      Rails.logger.info "AX Resp Data: #{ax_resp.data.inspect}"
      sti_id = ax_resp.data["http://powerschool.com/entity/id"][0]  
      school_id = ax_resp.data["http://powerschool.com/entity/schoolID"][0]
      district_name = ax_resp.data["http://powerschool.com/entity/districtName"][0] 
      district = District.where(name: district_name).first
      email = ax_resp.data["http://powerschool.com/entity/email"][0]            
      Rails.logger.info("sti_id: #{sti_id.inspect}")
      @person = Person.where(district_guid: district.guid, sti_id: sti_id).first
      if !@person
        flash[:error] = "Person within district #{district_name}:#{district.guid} having sis id #{sti_id} not found!"
        render :layout => false and return    
        #redirect_to "/" and return        
      end
      if !@person.user
        flash[:error] = "User with email #{email} not found!"
        render :layout => false and return    
        #redirect_to "/" and return        
      end      
      @school = School.where(district_guid: district.guid, legacy_school_id: school_id).first
      @school = @person.schools.first unless @school
      redirect_to "https://#{request.domain}/sti/auth?districtGUID=#{district.guid}&sti_school_id=#{@school.sti_id}&userid=#{@person.sti_id}" and return
    when OpenID::Consumer::SETUP_NEEDED
      flash[:alert] = "Immediate request failed - Setup Needed"
    when OpenID::Consumer::CANCEL  
      flash[:alert] = "OpenID transaction cancelled."
    else
    end
    render :layout => false and return    
  end

  private

  def consumer
    if @consumer.nil?
      dir = Pathname.new(Rails.root).join('db').join('cstore')
      store = OpenID::Store::Filesystem.new(dir)
      @consumer = OpenID::Consumer.new(session, store)
    end
    return @consumer
  end
end