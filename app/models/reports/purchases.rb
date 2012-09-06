module Reports
  class Purchases < Reports::Base
    def initialize params
      super
      @school = params[:school]
    end

    def orders
      Spree::Order.where(store_id: @school.store.id)
    end

    def line_items
      Spree::LineItem.includes(:order).where(order: { store_id: @school.store.id })
    end

    def execute!
      # get recent line items from the school
      line_items.each do |line_item|
        @data << generate_row(line_item)
      end
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
