module Reports
  class Purchases < Reports::Base
    include DateFilterable
    include ActionView::Helpers

    # Handle Kaminari
    delegate :total_pages, :limit_value, :current_page, :to => :reward_deliveries

    attr_accessor :parameters
    def initialize params
      super
      @school = params[:school]
      @parameters = Reports::Purchases::Params.new(params)
    end

    def execute!
      # get recent line items from the school
      reward_deliveries.each do |reward_delivery|
        if reward_delivery.reward && reward_delivery.reward.product # Guard against deleted rewards
          @data << generate_row(reward_delivery)
        end
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
      if parameters.paginate == "1"
        base_scope = base_scope.page(parameters.page).per(parameters.per_page)
      end
      base_scope
    end

    def sort_by
      case parameters.sort_by
      when "Default"
        [:scoped]
      when "Teacher"
        [:order, :from_id]
      when "Grade"
        [:order_by_student_grade]
      when "Student"
        [:order, :to_id]
      when "Newest Purchases"
        [:newest_orders]
      when "Oldest Purchases"
        [:oldest_orders]
      when "Reward"
        [:order, "spree_products.name"]
      when "Status"
        [:order, :status]
      end
    end

    def reward_status_filter
      case parameters.reward_status_filter
      when 'undelivered'
        [:where, {status: "pending"}]
      when 'delivered'
        [:where, {status: "delivered"}]
      else
        [:scoped]
      end
    end

    def teachers_filter
      if parameters.teachers_filter.blank?
        [:scoped]
      else
        [:where, { from_id: parameters.teachers_filter }]
      end
    end

    def reward_delivery_base_scope
      RewardDelivery.includes(to: [ :person_school_links ], reward: [:product]).where(to: { person_school_links: { school_id: @school.id } })
    end

    def generate_row(reward_delivery)
      person = reward_delivery.to
      deliverer = reward_delivery.from
      classroom = person.classrooms.first
      teacher   = classroom.teachers.first
      Reports::Row[
        delivery_teacher: name_with_options(deliverer, parameters.teachers_name_option),
        student: [name_with_options(person, parameters.students_name_option), "(#{person.user.username})"].join(" "),
        classroom: (person.classrooms.count > 0 ? "#{teacher.last_name}: #{person.classrooms.first.name}" : ""),
        grade: School::GRADE_NAMES[person.grade],
        purchased: time_ago_in_words(reward_delivery.created_at) + " ago",
        reward: reward_delivery.reward.product.name,
        quantity: reward_delivery.reward.quantity,
        status: reward_delivery.status.humanize,
        reward_delivery_id: reward_delivery.id,
        delivery_status: reward_delivery.status
      ]
    end

    def name_with_options(person, option = "Last, First")
      name_array = [person.last_name, person.first_name]
      name_array.reverse! if option == "First, Last"
      option == "Last, First" || option == "" ? name_array.join(", ") : name_array.join(" ")
    end

    def headers
      {
        delivery_teacher: "Delivery Teacher",
        student: "Student (username)",
        classroom: "Classroom",
        grade: "Grade",
        purchased: "Purchased",
        reward: "Reward",
        quantity: "Quantity",
        status: "Status"
      }
    end
    class Params < Reports::ParamsBase
      attr_accessor :date_filter, :reward_status_filter, :teachers_filter, :students_name_option, :teachers_name_option, :sort_by

      def initialize options_in = {}
        super
        options_in ||= {}
        options = options_in[self.class.to_s.gsub("::",'').tableize] || options_in || {}
        [:date_filter, :reward_status_filter, :teachers_filter, :sort_by, :students_name_option, :teachers_name_option].each do |iv|
          default_method = (iv.to_s + "_default").to_sym
          default_value = nil
          default_value = send(default_method) if respond_to? default_method
          instance_variable_set(('@' + iv.to_s).to_sym,options[iv] || default_value || "")
        end
      end

      def student_name_options
        ["Last, First", "First, Last"]
      end

      def teacher_name_options
        ["Last, First", "First, Last"]
      end

      def reward_status_filter_default
        "undelivered"
      end

      def reward_status_filter_options
        [
          ['Everything', "all"],
          ['Undelivered', "undelivered"],
          ['Delivered','delivered']
        ]
      end

      def teachers_filter_default
        if teachers_filter_options
          teachers_filter_options[0]
        else
          nil
        end
      end

      def teachers_filter_options(school = nil)
        school.teachers.order(:last_name, :first_name).collect do |t| 
          [t.name, t.id]
        end if school
      end

      def sort_by_default
        sort_by_options[0]
      end

      def sort_by_options
        ["Default", "Teacher", "Student", "Grade", "Newest Purchases","Oldest Purchases", "Reward", "Status"]
      end

      def date_filter_default
        'this_month'
      end
    end
  end
end
