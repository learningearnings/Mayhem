module ReportsHelper
  def date_filter_options
    [
      ['Everything', "all"],
      ['Last 90 Days', "last_90_days"],
      ['Last 60 Days', "last_60_days"],
      ['Last Month', "last_month"],
      ['This Month', "this_month"],
      ['This Week', "this_week"],
      ['Last Week', "last_week"],
      ['Last 7 Days', "last_7_days"]
    ]
  end
end
