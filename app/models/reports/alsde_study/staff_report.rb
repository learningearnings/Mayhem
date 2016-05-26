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
        @districts = options[:districts]
      end

      def run
        if @districts
          school_ids =  School.where(district_guid: @districts).pluck(:id)
        else
          school_ids =  School.where(district_guid: District.where(alsde_study: true).pluck(:guid)).pluck(:id)
        end
        staff = Teacher.includes(:user).joins(:allperson_school_links,:spree_user).where(status: 'active', allperson_school_links: { status: "active", school_id: school_ids })
        CSV.generate do |csv|
          csv << ["district_name","sti_district_guid", "sti_school_id", "sti_user_id", "le_person_id", "status", "first_login_date", "login_count", "sum_credits_awarded", "has_a_classroom?", "grade"]
          staff.each_with_index do |staff_member, index|
            if staff_member.user            
              csv << [
                  District.where(guid: staff_member.district_guid).pluck(:name).first,
                  staff_member.district_guid,
                  # TODO: This might be incorrect if a staff_member belongs to multiple schools
                  staff_member.school.try(:sti_id),
                  staff_member.sti_id,
                  staff_member.id,
                  staff_member.status,
                  staff_member.interactions.between(@start_date, @end_date).first.try(:created_at).try(:strftime, "%m/%d/%Y"),
                  staff_member.interactions.staff_login_between(@start_date, @end_date).count,
                  # TODO: Make sure this is right
                  staff_member.otu_codes.created_between(@start_date, @end_date).sum(:points).to_s,
                  staff_member.person_school_classroom_links.where(status: "active").size > 0,
                  staff_member.grade
              ]  
              puts "Processing teacher #{index} of #{staff.size}" 
            end
          end
        end
      end
      
      def run_non_alsde
        school_ids =  School.where(" credits_scope = 'School-Wide' or credits_scope is null  and district_guid is not null and district_guid not in (select district_guid from districts where alsde_study = 't' )").pluck(:id)
        staff = Teacher.includes(:user).joins(:allperson_school_links,:spree_user).where(status: 'active', allperson_school_links: { status: "active", school_id: school_ids })
        csvdata = CSV.generate do |csv|
          csv << ["sti_district_guid", "sti_school_id", "sti_user_id", "le_person_id", "status", "first_login_date", "login_count", "sum_credits_awarded", "has_a_classroom?", "grade"]
          staff.each_with_index do |staff_member, index|
            if staff_member.user            
              csv << [
                  staff_member.district_guid,
                  # TODO: This might be incorrect if a staff_member belongs to multiple schools
                  staff_member.school.try(:sti_id),
                  staff_member.sti_id,
                  staff_member.id,
                  staff_member.status,
                  staff_member.interactions.between(@start_date, @end_date).first.try(:created_at).try(:strftime, "%m/%d/%Y"),
                  staff_member.interactions.staff_login_between(@start_date, @end_date).count,
                  # TODO: Make sure this is right
                  staff_member.otu_codes.created_between(@start_date, @end_date).sum(:points).to_s,
                  staff_member.person_school_classroom_links.where(status: "active").size > 0,
                  staff_member.grade
              ]  
              puts "Processing teacher #{index} of #{staff.size}" 
            end
          end
        end
      end      
    end
  end
end
