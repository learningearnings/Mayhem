module Reports
  class UserActivityReport

    def run
      csv = CSV.generate do |csv|
        csv << ["Teachers logged 30 days", "active teachers logged 7", "Teachers created/loggedin within 7 days", "Students logged 30 days", "active students logged 7", "Purchases in the last 7"]
        csv_array = []
        csv_array << Teacher.recently_logged_in.count
        csv_array << ActionController::Base.helpers.number_to_percentage(BigDecimal(Teacher.logged_in_between(7.days.ago, Time.zone.now).count) / BigDecimal(Teacher.recently_logged_in.count) * 100, precision: 0)
        csv_array << Teacher.created_between(7.days.ago, Time.zone.now).logged_in_between(7.days.ago, Time.zone.now).count
        csv_array << Student.recently_logged_in.count
        csv_array << ActionController::Base.helpers.number_to_percentage(BigDecimal(Student.logged_in_between(7.days.ago, Time.zone.now).count) / BigDecimal(Student.recently_logged_in.count) * 100, precision: 0)
        csv_array << Student.created_between(7.days.ago, Time.zone.now).logged_in_between(7.days.ago, Time.zone.now).count
        csv_array << RewardDelivery.except_refunded.in_last_7_days.count
        csv << csv_array
      end
    end
  end
end
