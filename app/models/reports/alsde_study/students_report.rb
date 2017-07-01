module Reports
  module ALSDEStudy
    class StudentsReport
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
        students = Student.includes(:user).joins(:allperson_school_links,:spree_user).where(status: "active", allperson_school_links: { school_id: school_ids, status: "active" })
        CSV.generate do |csv|
          csv << ["district_name","sti_district_guid", "sti_school_id", "sti_user_id", "le_person_id", "grade", "status", "first_login_date", "login_count", "sum_credits_deposited", "sum_credits_spent_on_purchases"]
          students.each_with_index do |student, index |
            if student.user
              csv << [
                District.where(guid: student.district_guid).pluck(:name).first,
                student.district_guid,
                student.school.try(:sti_id),
                student.sti_id,
                student.id,
                student.grade,
                student.status,
                student.interactions.between(@start_date, @end_date).first.try(:created_at).try(:strftime, "%m/%d/%Y"),
                student.interactions.student_login_between(@start_date, @end_date).count,
                # TODO: Make sure this is right
                begin
                  student.otu_codes.redeemed_between(@start_date, @end_date).sum(:points).to_s
                rescue
                  "0"
                end,
                sum_credits_spent_on_purchases_for(student)
              ]
              puts "Processing student #{index} of #{students.size}"              
            end
          end         
        end
      end
      
      def run_non_alsde
        school_ids = School.where(" credits_scope = 'School-Wide' or credits_scope is null  and district_guid is not null and district_guid not in (select district_guid from districts where alsde_study = 't' )").pluck(:id)
        students = Student.includes(:user).joins(:allperson_school_links,:spree_user).where(status: "active", allperson_school_links: { school_id: school_ids, status: "active" })
        CSV.generate do |csv|
          csv << ["sti_district_guid", "sti_school_id", "sti_user_id", "le_person_id", "grade", "status", "first_login_date", "login_count", "sum_credits_deposited", "sum_credits_spent_on_purchases"]
          students.each_with_index do |student, index |
            if student.user
              csv << [
                student.district_guid,
                student.school.try(:sti_id),
                student.sti_id,
                student.id,
                student.grade,
                student.status,
                student.interactions.between(@start_date, @end_date).first.try(:created_at).try(:strftime, "%m/%d/%Y"),
                student.interactions.student_login_between(@start_date, @end_date).count,
                # TODO: Make sure this is right
                student.otu_codes.redeemed_between(@start_date, @end_date).sum(:points).to_s,
                sum_credits_spent_on_purchases_for(student)
              ]
              puts "Processing student #{index} of #{students.size}"              
            end
          end         
        end
      end


      private

      def sum_credits_spent_on_purchases_for(student)
        if student.checking_account
          purchases = student.checking_account.transactions.created_between(@start_date, @end_date).where("description ILIKE '%purchase%'")
          purchase_amounts = purchases.flat_map(&:debit_amounts).map(&:amount).inject(:+).to_i
          refunds = student.checking_account.transactions.created_between(@start_date, @end_date).where("description ILIKE '%refund%'")
          refund_amounts = refunds.flat_map(&:debit_amounts).map(&:amount).inject(:+).to_i
          (purchase_amounts - refund_amounts).to_s
        else
          "0"
        end
      end
    end
  end
end
