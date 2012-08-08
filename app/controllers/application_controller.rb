require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery

  def after_sign_out_path_for(resource_or_scope)
    '/'
  end
  
end
