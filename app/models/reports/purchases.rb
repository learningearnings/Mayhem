module Reports
  class Purchases < Reports::Base
    def initialize params
      super
      @school = params[:school]
      @date_filter = params[:date_filter]
      @reward_status_filter = params[:reward_status_filter]
      @teachers_filter = params[:teachers_filter]
    end

    def execute!
      # get recent line items from the school
      reward_deliveries.each do |reward_delivery|
        @data << generate_row(reward_delivery)
      end
    end

    # Will include date_filter, reward_status_filter(delivered, undelivered) and teachers_filter
    # Only Date Filter for now.
    def potential_filters
      [:date_filter, :reward_status_filter, :teachers_filter]
    end

    def reward_deliveries
      base_scope = reward_delivery_base_scope
      potential_filters.each do |filter|
        filter_option = send(filter)
        base_scope = base_scope.send(*filter_option) if filter_option
      end
      base_scope
    end

    # This feels all cluttered to me but my brain isn't firing on all cylinders today.
    def date_filter
      case @date_filter
      when 'last_90_days'
        [:where, {created_at: 90.days.ago..1.second.ago}]
      when 'last_60_days'
        [:where, {created_at: 60.days.ago..1.second.ago}]
      when 'last_7_days'
        [:where, {created_at: 7.days.ago..1.second.ago}]
      when 'last_month'
        d_begin = Time.now.beginning_of_month - 1.month
        d_end = d_begin.end_of_month
        [:where, {created_at: d_begin..d_end}]
      when 'this_month'
        [:where, {created_at: Time.now.beginning_of_month..Time.now}]
      when 'this_week'
        [:where, {created_at: Time.now.beginning_of_week..Time.now}]
      when 'last_week'
        d_begin = Time.now.beginning_of_week - 1.week
        d_end = d_begin.end_of_week
        [:where, {created_at: d_begin..d_end}]
      else
        [:scoped]
      end
    end

    def reward_status_filter
      case @reward_status_filter
      when 'Undelivered'
        :pending
      when 'Delivered'
        :delivered
      else
        nil
      end
    end

    def teachers_filter
      case @teachers_filter
      when 'everyone'
        nil
      else
        [:where, { from_id: @teachers_filter }]
      end
    end

    def reward_delivery_base_scope
      RewardDelivery.includes(to: [ :person_school_links ]).where(to: { person_school_links: { school_id: @school.id } })
    end

    def generate_row(reward_delivery)
      person = reward_delivery.to
      deliverer = reward_delivery.from
      Reports::Row[
        delivery_teacher: deliverer,
        classroom: "",
        student: [person, "(#{person.user.username})"].join(" "),
        grade: person.grade,
        purchased: reward_delivery.created_at.to_s(:db),
        reward: reward_delivery.reward.name,
        status: "Stock",
        reward_delivery_id: reward_delivery.id,
        delivery_status: reward_delivery.status
      ]
    end

    def headers
      {
        delivery_teacher: "Delivery Teacher",
        classroom: "Classroom",
        student: "Student (username)",
        grade: "Grade",
        purchased: "Purchased",
        reward: "Reward",
        status: "Status"
      }
    end
  end
end
