load 'lib/sti/client.rb'
class StiController < ApplicationController
  include Mixins::Banks
  helper_method :current_school, :current_person

  def give_credits
    sti_client = STI::Client.new
    sti_client.session_token = params["sti_session_variable"]
    load_students
    render :layout => false
  end

  private
  def load_students
    @students = current_person.schools.first.students.where(sti_id: params["studentIds"].split(","))
  end

  def current_person
    Teacher.find(178)
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
