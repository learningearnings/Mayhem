class EventsController < ApplicationController
  def log_tour_event
    step = params[:tour_step].to_i
    tour_name = params[:tour_name]
    end_tour = params[:is_last_step]
    
    event = TourEvent.new
    event.event_name = "View Tour Step"
    event.tour_name = tour_name
    event.tour_step = step
    event.person = current_person
    event.save
    
    if step == 1
      #Create tour start event
      event = TourEvent.new
      event.event_name = "Begin Tour"
      event.tour_name = tour_name
      event.tour_step = step
      event.person = current_person
      event.save      
    end
    
    if end_tour == "true"
      #Create tour end event
      event = TourEvent.new
      event.event_name = "End Tour"
      event.tour_name = tour_name
      event.tour_step = step
      event.person = current_person
      event.save           
    end
    
  end
end
