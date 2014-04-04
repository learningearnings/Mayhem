module Reports
  class ActiveTeacherReport
    attr_accessor :start_date, :end_date, :teachers, :base_scope, :bucket

    def initialize options={}
      self.start_date = options.fetch(:start_date) { Time.now.beginning_of_day }
      self.end_date = options.fetch(:end_date) { Time.now.end_of_day }
      self.base_scope = options.fetch(:base_scope) { Teacher }
    end

    def run
      self.bucket = base_scope
      self.bucket = self.bucket.logged_in_between(start_date, end_date)
      self.bucket = self.bucket.includes(:otu_codes)
      self.bucket = self.bucket.where(OtuCode.arel_table[:created_at].gteq(start_date))
      self.bucket = self.bucket.where(OtuCode.arel_table[:created_at].lteq(end_date))
      self.bucket = self.bucket.uniq

      to_csv
    end

    def to_csv
      CSV.generate do |csv|
        csv << ["School Name", "Teacher First", "Teacher Last", "Teacher Email"]
        bucket.each_slice(100) do |teacher_slice|
          teacher_slice.each do |teacher|
            csv << [teacher.schools.first.name, teacher.first_name, teacher.last_name, teacher.user.email]
          end
        end
      end
    end
  end
end
