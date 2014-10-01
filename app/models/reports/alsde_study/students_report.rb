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
        students = Student.joins(:allperson_school_links).where(allperson_school_links: { school_id: school_ids }).logged_in_between(@start_date, @end_date)
        CSV.generate do |csv|
          csv << ["sti_district_guid", "sti_user_id", "le_person_id", "grade", "status", "first_login_date", "login_count", "sum_credits_deposited", "sum_credits_spent_on_purchases"]
          students.each do |student|
            csv << [
              student.district_guid,
              student.user.id,
              student.id,
              student.grade,
              student.status,
              student.interactions.first,
              student.user.sign_in_count,
              # TODO: Make sure this is right
              student.otu_codes.where('redeemed_at IS NOT NULL').sum(:points).to_s,
              sum_credits_spent_on_purchases_for(student)
            ]
          end
        end
      end

      private

      def sum_credits_spent_on_purchases_for(student)
        purchases = student.checking_account.transactions.where("description ILIKE '%purchase%'")
        purchase_amounts = purchases.flat_map(&:debit_amounts).map(&:amount).inject(:+).to_i
        refunds = student.checking_account.transactions.where("description ILIKE '%refund%'")
        refund_amounts = refunds.flat_map(&:debit_amounts).map(&:amount).inject(:+).to_i
        (purchase_amounts - refund_amounts).to_s
      end
    end
  end
end
