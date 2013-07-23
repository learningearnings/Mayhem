class LoggedInController < ApplicationController
  before_filter :authenticate_user!
  before_filter :push_content_section
  layout 'resp_application'

  def current_school
    School.find(session[:current_school_id])
  end

  def current_person
    current_user.person
  end

  protected
  def push_content_section
    @push_content_section = true
  end
end
