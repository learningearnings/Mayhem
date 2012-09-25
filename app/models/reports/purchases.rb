module Reports
  class Purchases < Reports::Base
    include DateFilterable

    def initialize params
      super
      @school = params[:school]
      @date_filter = params[:date_filter]
      @reward_status_filter = params[:reward_status_filter]
      @teachers_filter = params[:teachers_filter]
      @sort_by_filter = params[:sort_by]
    end

    def execute!
      # get recent line items from the school
      reward_deliveries.each do |reward_delivery|
        @data << generate_row(reward_delivery)
      end
    end

    def filters_in_text
      text = ""
      if @reward_status_filter
        case @reward_status_filter
        when "Everything"
          text << "All"
        else
          text << @reward_status_filter
        end
      end
      text << " Purchases"
      if date_endpoints
        text << " from #{date_endpoints[0].to_date.to_s(:db)} to #{date_endpoints[1].to_date.to_s(:db)}"
      end
      text
    end

    # Will include date_filter, reward_status_filter(delivered, undelivered) and teachers_filter
    # Only Date Filter for now.
    def potential_filters
      [:date_filter, :reward_status_filter, :teachers_filter, :sort_by]
    end

    def reward_deliveries
      base_scope = reward_delivery_base_scope
      potential_filters.each do |filter|
        filter_option = send(filter)
        base_scope = base_scope.send(*filter_option) if filter_option
      end
      base_scope
    end

    def sort_by
      case @sort_by_filter
      when "Default"
        [:scoped]
      when "Teacher"
        [:order, :from_id]
      when "Student"
        [:order, :to_id]
      when "Purchased"
        [:order, :created_at]
      when "Reward"
        [:order, "spree_products.name"]
      when "Status"
        [:order, :status]
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
      RewardDelivery.includes(to: [ :person_school_links ], reward: []).where(to: { person_school_links: { school_id: @school.id } })
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
        status: reward_delivery.status,
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
