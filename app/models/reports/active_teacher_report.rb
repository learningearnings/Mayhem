module Reports
  class ActiveTeacherReport
    attr_accessor :start_date, :end_date

    def initialize options={}
      self.start_date = options.fetch(:start_date) { Time.now.beginning_of_day }
      self.end_date = options.fetch(:end_date) { Time.now.end_of_day }
    end

    def run
      @teachers = Teacher.logged_in_between(start_date, end_date).includes(:otu_codes).where(OtuCode.arel_table[:created_at].gteq(start_date)).where(OtuCode.arel_table[:created_at].lteq(end_date)).uniq
      to_csv
    end

    def to_csv
      CSV.generate do |csv|
        csv << ["School Name", "Teacher First", "Teacher Last", "Teacher Email"]
        @teachers.each do |teacher|
          csv << [teacher.schools.first.name, teacher.first_name, teacher.last_name, teacher.user.email]
        end
      end
    end
  end
end
