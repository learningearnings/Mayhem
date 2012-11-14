module Reports
  module DateFilterable
    def date_filter
      case date_endpoints
      when nil
        [:scoped]
      else
        [:where, {created_at: date_endpoints[0]..date_endpoints[1]}]
      end
    end

    def date_endpoints
      case @date_filter
      when 'last_90_days'
        [90.days.ago.beginning_of_day, 1.second.from_now]
      when 'last_60_days'
        [60.days.ago.beginning_of_day, 1.second.from_now]
      when 'last_7_days'
        [7.days.ago.beginning_of_day, 1.second.from_now]
      when 'last_month'
        d_begin = Time.now.beginning_of_month - 1.month
        d_end = d_begin.end_of_month
        [d_begin, d_end]
      when 'this_month'
        [Time.now.beginning_of_month, Time.now]
      when 'this_week'
        [Time.now.beginning_of_week, Time.now]
      when 'last_week'
        d_begin = Time.now.beginning_of_week - 1.week
        d_end = d_begin.end_of_week
        [d_begin, d_end]
      else
        nil
      end
    end
  end
end
