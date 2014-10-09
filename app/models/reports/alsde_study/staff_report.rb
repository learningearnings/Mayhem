module Reports
  module ALSDEStudy
    class StaffReport
      def initialize(options={})
        @start_date = options.fetch("start_date", Time.zone.now - 30.days)
        @start_date = Time.zone.parse(@start_date) if @start_date.is_a?(String)
        @start_date = @start_date.beginning_of_day
        @end_date   = options.fetch("end_date"  , Time.zone.now)
        @end_date   = Time.zone.parse(@end_date).end_of_day if @end_date.is_a?(String)
        @end_date   = @end_date.end_of_day
      end

      def run
        school_ids =  School.where(district_guid: District.where(alsde_study: true).pluck(:guid)).pluck(:id)
        staff = Teacher.joins(:allperson_school_links).where(allperson_school_links: { school_id: school_ids })
        CSV.generate do |csv|
          csv << ["sti_district_guid", "sti_school_id", "sti_user_id", "le_person_id", "status", "first_login_date", "login_count", "sum_credits_awarded", "has_a_classroom?", "grade"]
          staff.each do |staff_member|
            csv << [
              staff_member.district_guid,
              # TODO: This might be incorrect if a staff_member belongs to multiple schools
              staff_member.school.sti_id,
              staff_member.sti_id,
              staff_member.id,
              staff_member.status,
              staff_member.interactions.first.try(:created_at).try(:strftime, "%m/%d/%Y"),
              staff_member.user.sign_in_count,
              # TODO: Make sure this is right
              staff_member.otu_codes.created_between(@start_date, @end_date).sum(:points).to_s,
              staff_member.classrooms.any?,
              staff_member.grade
            ]
          end
        end
      end
    end
  end
end