class PollsController < ApplicationController

  def vote
    if params[:poll_id] && params[:vote]
      @poll = Poll.find params[:poll_id]
      @vote = Vote.find_or_create_by_person_id_and_poll_id(:person_id => current_person.id, :poll_id => @poll.id, :poll_choice_id => params[:vote][:poll_choice_id])
      redirect_to @poll
    else
      flash[:error] = "Please provide all the required information to vote in the poll"
      redirect_to @poll
    end
  end

  def index
    @polls = Poll.active
  end

  def show
    @poll = Poll.find params[:id]
  end

  def poll_form
    @poll = Poll.find params[:id]
  end


end
