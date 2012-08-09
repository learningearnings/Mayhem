class LoggedInController < ApplicationController
  before_filter :authenticate_user!

  def current_person
    current_user.person
  end
end
