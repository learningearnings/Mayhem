module Reports
  class SignUpsReport
    attr_reader :beginning_day, :ending_day, :total_days

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
      @person_ids = Interaction.between(@beginning_day,@ending_day).where(:page => "teachers/signup").pluck(:person_id).uniq
      @teachers = Teacher.where(status: "active", id: @person_ids)
    end

    def run
      csv = CSV.generate do |csv|
        csv << ["Sign Ups Report"]
        csv << [""]
        csv << ["There were #{@person_ids.size} new teacher sign ups this period"]
        csv << [""]
        csv << ["First Name","Last Name","Email","School","Created Date","Last Login Date"]
        csv << [""]
        @teachers.each do | teacher |
          csv << [teacher.first_name, teacher.last_name, teacher.user.email, teacher.school.name, teacher.user.created_at, teacher.user.last_sign_in_at]
        end
      end
      csv
    end

  end
end
