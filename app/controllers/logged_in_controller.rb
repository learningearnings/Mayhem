class LoggedInController < ApplicationController
  before_filter :authenticate_user!

  def current_school
    School.find(session[:current_school_id])
  end

  def current_person
    current_user.person
  end
end
