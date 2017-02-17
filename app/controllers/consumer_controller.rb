require 'pathname'

require "openid"
require 'openid/extensions/ax'
require 'openid/extensions/sreg'
require 'openid/extensions/pape'
require 'openid/store/filesystem'

class ConsumerController < ApplicationController
  layout nil

  def index
    render :layout => false
    # render an openid form
  end

  def start
    begin
      identifier = params[:openid_identifier]
      Rails.logger.info("AKT: SSO Start params: #{params.inspect}")
      if identifier.nil?
        flash[:error] = "Enter an OpenID identifier"
        redirect_to :action => 'index'
        return
      end
      oidreq = consumer.begin(identifier)
    rescue OpenID::OpenIDError => e
      flash[:error] = "Discovery failed for #{identifier}: #{e}"
      redirect_to :action => 'index'
      return
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
    #realm = url_for :action => 'index', :id => nil, :only_path => false
    realm = "https://demo.learningearnings.com/"
    Rails.logger.info("AKT: SSO Start realm: #{realm.inspect}")
    Rails.logger.info("AKT: SSO Start return_to: #{return_to.inspect}")    
    if oidreq.send_redirect?(realm, return_to, params[:immediate])
      Rails.logger.info("AKT: SSO Start redirect to oidreq.redirect_url: #{oidreq.inspect}")
      redirect_to oidreq.redirect_url(realm, return_to, params[:immediate])
    else
      Rails.logger.info("AKT: SSO Start render text : #{oidreq.inspect}")
      render :text => oidreq.html_markup(realm, return_to, params[:immediate], {'id' => 'openid_form'})
    end
  end

  def complete
    # FIXME - url_for some action is not necessarily the current URL.
    Rails.logger.info("AKT: SSO Complete params: #{params.inspect}")    
    current_url = url_for(:action => 'complete', :only_path => false)
    parameters = params.reject{|k,v|request.path_parameters[k]}
    parameters.reject!{|k,v|%w{action controller}.include? k.to_s}
    Rails.logger.info("AKT: SSO Complete parameters: #{parameters.inspect}")
    oidresp = consumer.complete(parameters, current_url)
    openid = oidresp.display_identifier
    Rails.logger.info("AKT: SSO Complete oidresp: #{oidresp.inspect}")
    case oidresp.status
    when OpenID::Consumer::FAILURE
      Rails.logger.info("AKT: SSO Complete Failure: #{oidresp.inspect}")
      if oidresp.display_identifier
        flash[:error] = ("Verification of #{oidresp.display_identifier}"\
                         " failed: #{oidresp.message}")
      else
        flash[:error] = "Verification failed: #{oidresp.message}"
      end
    when OpenID::Consumer::SUCCESS
      ax_resp = OpenID::AX::FetchResponse.from_success_response(oidresp)
      ax_message = "Simple Registration data was requested"
      ax_message << ". The following data were sent:"
      ax_resp.data.each do |k,v|
        ax_message << "<br/><b>#{k}</b>: #{v}"
      end
      Rails.logger.info("AKT: #{ax_message}")
      flash[:success] = ax_message  # startup something    
      sti_id = ax_resp.data["http://powerschool.com/entity/dcid"][0]  
      school_id = ax_resp.data["http://powerschool.com/entity/schoolID"][0]
      district_name = ax_resp.data["http://powerschool.com/entity/districtName"][0] 
      email = ax_resp.data["http://powerschool.com/entity/email"][0]            
      Rails.logger.info("sti_id: #{sti_id.inspect}")
      @district = District.where(name: district_name).first
      @person = Person.where(district_guid: @district.guid, sti_id: sti_id).first
      @school = School.where(district_guid: @district.guid, sti_id: school_id).first
      session[:current_school_id] = @person.school.id  
      sign_in(@person.user)
      redirect_to "/" and return
      

    when OpenID::Consumer::SETUP_NEEDED
      Rails.logger.info("AKT: SSO Complete FAILED setup needed")
      flash[:alert] = "Immediate request failed - Setup Needed"
    when OpenID::Consumer::CANCEL
      Rails.logger.info("AKT: SSO Complete FAILED transaction canceled")      
      flash[:alert] = "OpenID transaction cancelled."
    else
    end
    redirect_to :action => 'index'
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