module Reports
  class UserActivityReport

    def run
      csv = CSV.generate do |csv|
        csv << ["Teachers who logged in within the last 30 days", "% of active teachers who logged in in the last 7 days", "Teachers created within the last 7 days and logged in within the same period", "Students logged in within 30 days", "% of active students who logged in within the last 7 days", "Count of rewards purchased in the last 7 days"]
        csv_array = []
        csv_array << Teacher.recently_logged_in.count
        csv_array << Teacher.logged_in_between(7.days.ago, Time.zone.now).count / Teacher.recently_logged_in.count
        csv_array << Teacher.created_between(7.days.ago, Time.zone.now).logged_in_between(7.days.ago, Time.zone.now).count
        csv_array << Student.recently_logged_in.count
        csv_array << Student.logged_in_between(7.days.ago, Time.zone.now).count / Student.recently_logged_in.count
        csv_array << RewardDelivery.except_refunded.in_last_7_days.count
        csv << csv_array
      end
    end
  end
end
