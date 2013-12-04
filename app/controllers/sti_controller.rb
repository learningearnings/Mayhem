load 'lib/sti/client.rb'
class StiController < ApplicationController
  include Mixins::Banks
  helper_method :current_school, :current_person
  skip_around_filter :track_interaction

  def give_credits
    sti_client = STI::Client.new
    sti_client.session_token = params["sti_session_variable"]
    @client_response = sti_client.session_information.parsed_response
    if @client_response["StaffId"].blank? || current_person.nil?
      render partial: "teacher_not_found"
    else
      load_students
      render :layout => false
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
end
