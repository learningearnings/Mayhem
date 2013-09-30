class LoggedInController < ApplicationController
  before_filter :authenticate_user!
  before_filter :push_content_section

  def current_person
    current_user && current_user.person
  end

  protected
  def push_content_section
    @push_content_section = true
  end
end
