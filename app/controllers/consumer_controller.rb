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
    sregreq = OpenID::AX::Request.new
    # required fields
    sregreq.request_fields(['dcid','usertype','email','schoolID'], true)
    # optional fields
    #sregreq.request_fields(['dob', 'gender','postcode'], false)
    oidreq.add_extension(sregreq)
    oidreq.return_to_args['did_ax'] = 'y'
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
      username = oidresp.display_identifier.split('/').last 
      #flash[:success] = ("Verification of #{username} succeeded.")
      Rails.logger.info("Verification of #{username} succeeded.")                 
      #flash[:sreg_results] = username
      Rails.logger.info("Sreg Params: #{params.inspect}")
      #user = Spree::User.where(username: username).first
      #person = user.person
      #session[:current_school_id] = person.school.id 
      #sign_in(user)
      #redirect_to "/" and return
      

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