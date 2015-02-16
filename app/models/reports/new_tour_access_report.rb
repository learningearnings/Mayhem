module Reports
  class NewTourAccessReport
    
    def initialize options = {}
      if options.has_key?("beginning_day")
        @beginning_day = Time.zone.parse(options["beginning_day"]).beginning_of_day
      else
        @beginning_day = (Time.zone.now - 30.days).beginning_of_day
      end
      if options.has_key?("ending_day")
        @ending_day = Time.zone.parse(options["ending_day"]).end_of_day
      else
        @ending_day = Time.zone.now.end_of_day
      end
      @total_days = (@ending_day.to_date - @beginning_day.to_date).to_i
      @tours = TourEvent.select("tour_name").between(@beginning_day, @ending_day).group("tour_name")
      
    end
    
    def run
      csv = CSV.generate do |csv|
        csv << ["Tour tracking report spaning #{@total_days} days"]
        csv << [""]
        @tours.each do | tour |
          csv << ["Tour #{tour.tour_name}"]
          csv << [""]
          @start_tour_count = TourEvent.between(@beginning_day, @ending_day).where(:tour_name => tour.tour_name, :event_name => 'Begin Tour').pluck(:person_id).uniq.count
          @end_tour_count = TourEvent.between(@beginning_day, @ending_day).where(:tour_name => tour.tour_name, :event_name => 'End Tour').pluck(:person_id).uniq.count        
          csv << ["","Count Started Tour", "Count Finished Tour"]
          csv << [""]          
          csv << ["",@start_tour_count, @end_tour_count]
          csv << [""] 
          @end_step = TourEvent.select("max(tour_step) as end_step").where(:tour_name => tour.tour_name, :event_name => 'End Tour').first.end_step
          @tour_people = TourEvent.select("person_id, max(tour_step) as max_step").between(@beginning_day, @ending_day).where(:tour_name => tour.tour_name).group("person_id")
          csv << ["","Person Id","Max Step","Tour Completed"]
          csv << [""]
          @tour_people.each do | tp |
            csv << ["",tp.person_id, tp.max_step, tp.max_step == @end_step]
          end
        end
      end
    end
  end
end
