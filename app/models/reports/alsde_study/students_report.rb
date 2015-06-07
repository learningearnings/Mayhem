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
      end

      def run
        school_ids =  School.where(district_guid: District.where(alsde_study: true).pluck(:guid)).pluck(:id)
        students = Student.joins(:allperson_school_links).where(allperson_school_links: { school_id: school_ids })
        CSV.generate do |csv|
          csv << ["sti_district_guid", "sti_school_id", "sti_user_id", "le_person_id", "grade", "status", "first_login_date", "login_count", "sum_credits_deposited", "sum_credits_spent_on_purchases"]
          students.each do |student|
            if student.user
              csv << [
                student.district_guid,
                student.school.try(:sti_id),
                student.sti_id,
                student.id,
                student.grade,
                student.status,
                student.interactions.first.try(:created_at).try(:strftime, "%m/%d/%Y"),
                student.user.sign_in_count,
                # TODO: Make sure this is right
                student.otu_codes.redeemed_between(@start_date, @end_date).sum(:points).to_s,
                sum_credits_spent_on_purchases_for(student)
              ]
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
