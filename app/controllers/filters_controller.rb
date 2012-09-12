class FiltersController < ApplicationController

  def filter_schools_by_state
    @schools = School.for_states(params[:states].map {|state_id| State.find_by_id state_id.to_i })
    render :text => @schools.map(&:name).join(", ")
  end
end
