module Reports
  class Purchases < Reports::Base
    def initialize params
      super
      @school = params[:school]
      @date_filter_option = params[:date_filter]
    end

    def execute!
      # get recent line items from the school
      line_items.each do |line_item|
        @data << generate_row(line_item)
      end
    end

    # Will include date_filter, rewards_filter(delivered, undelivered) and teachers_filter
    # Only Date Filter for now.
    def potential_filters
      [:date_filter]
    end

    def line_items
      base_scope = line_item_base_scope
      potential_filters.each do |filter|
        filter_option = send(filter)
        base_scope = base_scope.send(*filter_option) if filter_option
      end
      base_scope
    end

    # This feels all cluttered to me but my brain isn't firing on all cylinders today.
    def date_filter
      case @date_filter_option
      when 'last_90_days'
        [:where, {order: { completed_at: 90.days.ago..1.second.ago}}]
      when 'last_60_days'
        [:where, {order: { completed_at: 60.days.ago..1.second.ago}}]
      when 'last_7_days'
        [:where, {order: { completed_at: 7.days.ago..1.second.ago}}]
      when 'last_month'
        d_begin = Time.now.beginning_of_month - 1.month
        d_end = d_begin.end_of_month
        [:where, {order: { completed_at: d_begin..d_end}}]
      when 'this_month'
        [:where, {order: { completed_at: Time.now.beginning_of_month..Time.now}}]
      when 'this_week'
        [:where, {order: { completed_at: Time.now.beginning_of_week..Time.now}}]
      when 'last_week'
        d_begin = Time.now.beginning_of_week - 1.week
        d_end = d_begin.end_of_week
        [:where, {order: { completed_at: d_begin..d_end}}]
      else
        nil
      end
    end

    def line_item_base_scope
      Spree::LineItem.includes(:order).where(order: { store_id: @school.store.id })
    end

    def generate_row(line_item)
      order = line_item.order
      user = order.user
      person = user.person
      Reports::Row[
        delivery_teacher: "Foo",
        classroom: "",
        student: [person, "(#{user.username})"].join(" "),
        grade: person.grade,
        purchased: order.completed_at.to_s(:db),
        reward: line_item.variant.product.name,
        status: "Stock"
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
