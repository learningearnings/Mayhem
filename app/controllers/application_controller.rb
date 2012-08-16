require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery

  def after_sign_out_path_for(resource_or_scope)
    '/'
  end

  def ensure_le_admin!
    current_user.person.is_a?(LeAdmin)
  end
end
