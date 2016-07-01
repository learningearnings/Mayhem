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
      @teacher = params[:teacher]
      @current_page = params[:page]    
      @parameters = Reports::Purchases::Params.new(params)
    end

    def execute!    
      Rails.logger.debug("AKT: execute!")
      reward_deliveries.each do |reward_delivery|
        Rails.logger.debug("AKT: looping")
        if reward_delivery.reward && reward_delivery.reward.product # Guard against deleted rewards
          Rails.logger.debug("AKT: call generate row")
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


    def date_filter
      local_date_filter = parameters.date_filter if parameters && parameters.date_filter
      case local_date_filter
      when 'last_90_days'
        [:rewards_between, 90.days.ago.beginning_of_day, 1.second.from_now]
      when 'last_60_days'
        [:rewards_between, 60.days.ago.beginning_of_day, 1.second.from_now]
      when 'last_7_days'
        [:rewards_between, 7.days.ago.beginning_of_day, 1.second.from_now]
      when 'last_month'
        d_begin = Time.now.beginning_of_month - 1.month
        d_end = d_begin.end_of_month
        [:rewards_between, d_begin, d_end]
      when 'this_month'
        [:rewards_between, Time.now.beginning_of_month, Time.now]
      when 'this_week'
        [:rewards_between, Time.now.beginning_of_week, Time.now]
      when 'last_week'
        d_begin = Time.now.beginning_of_week - 1.week
        d_end = d_begin.end_of_week
        [:rewards_between, d_begin, d_end]
      else
        [:rewards_between, 10.years.ago,1.second.from_now]
      end
    end

    # Will include date_filter, reward_status_filter(delivered, undelivered) and teachers_filter
    # Only Date Filter for now.
    def potential_filters
      [:date_filter, :reward_status_filter, :teachers_filter, :reward_creator_filter, :sort_by]
    end

    def reward_deliveries
      base_scope = reward_delivery_base_scope
      potential_filters.each do |filter|
        filter_option = send(filter)
        base_scope = base_scope.send(*filter_option) if filter_option
      end
      #base_scope = base_scope.page(@current_page).per(200)
      base_scope
    end

    def sort_by
      case parameters.sort_by
      when "Default"
        [:scoped]
      when "Teacher"
        [:order, "from_id"]
      when "Grade"
        # I used people.grade in the following order statement because I wasn't sure
        # how to get the name of the join rails used for to. In every test I did it was
        # always people first, then froms_reward_deliveries for the from association
        # Hope this doesn't bite us :/
        [:order, "people.grade"]
      when "Student"
        [:order_by_student_last_name]
      when "Newest Purchases"
        [:newest_orders]
      when "Oldest Purchases"
        [:oldest_orders]
      when "Reward"
        [:order, "spree_products.name"]
      when "Status"
        [:order, "reward_deliveries.status"]
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
    
    def reward_creator_filter
      if parameters.page.blank?
        if @teacher
          rewards = @teacher.products.collect { | r | r.id }
          #[:where, { reward: {product: { id: rewards} } }]
          [:where, "spree_products.id IN (?) OR (reward_deliveries.delivered_by_id = ? OR (reward_deliveries.from_id =? AND reward_deliveries.delivered_by_id IS NULL)) ", rewards, @teacher.id, @teacher.id ]         
        else
          [:scoped]
        end 
      elsif parameters.reward_creator_filter.blank?
          [:scoped]      
      else
        #get all rewards created by the selected rewards creator
        teacher = Teacher.find(parameters.reward_creator_filter)
        rewards = teacher.products.collect { | r | r.id }
        #[:where, { reward: {product: { id: rewards} } }]
        [:where, "spree_products.id IN (?) OR (reward_deliveries.delivered_by_id = ? OR (reward_deliveries.from_id =? AND reward_deliveries.delivered_by_id IS NULL)) ", rewards, teacher.id, teacher.id ]         
      end
    end
    
    def teachers_filter
      if parameters.teachers_filter.blank?
        [:scoped]
      else
        #get all students for selected teacher
        students = []
        homeroom = Teacher.find(parameters.teachers_filter).homeroom     
        if homeroom
          students = homeroom.students.collect { | stu | stu.id }
          [:where, { to_id: students }]
        else
          [:where, { to_id: [] }]
        end
      end
    end

    def reward_delivery_base_scope
      RewardDelivery.includes(to: [ :person_school_links ], reward: [:product]).where(to: { person_school_links: { school_id: @school.id, status: 'active' } })
    end

    def generate_row(reward_delivery)
      Rails.logger.debug("AKT: generate row")
      person = reward_delivery.to
      deliverer = reward_delivery.reward.product.person ? reward_delivery.reward.product.person : reward_delivery.from
      homeroom = person.homeroom
      if homeroom
        teacher = homeroom.teachers.first
        if teacher
          cr_name = "#{teacher.try(:last_name)}: #{homeroom.name}"
        else
          cr_name = homeroom.name
        end
      else
        cr_name = "None"  
      end   
      Rails.logger.debug("AKT: homeroom #{cr_name}")
      Reports::Row[
        delivery_teacher: name_with_options(deliverer, parameters.teachers_name_option),
        delivered_by: reward_delivery.delivered_by.present? ? reward_delivery.delivered_by.name : reward_delivery.from.name,
        student: [name_with_options(person, parameters.students_name_option), "(#{person.user.username})"].join(" "),
        classroom: cr_name,
        grade: School::GRADE_NAMES[person.try(:grade)],
        purchased: reward_delivery.created_at,
        reward: reward_delivery.reward.product.name,
        quantity: reward_delivery.reward.quantity,
        status: reward_delivery.status.humanize,
        reward_delivery_id: reward_delivery.id,
        delivery_status: reward_delivery.status   
      ]
    end

    def name_with_options(person, option = "Last, First")
      name_array = [person.try(:last_name), person.try(:first_name)]
      name_array.reverse! if option == "First, Last"
      option == "Last, First" || option == "" ? name_array.join(", ") : name_array.join(" ")
    end

    def headers
      {
        delivery_teacher: "Reward Creator",
        delivered_by: "Delivered By",
        student: "Student (username)",
        grade: "Grade",
        purchased: "Purchased",
        reward: "Reward",
        quantity: "Quantity",
        status: "Status"
      }
    end
    class Params < Reports::ParamsBase
      attr_accessor :date_filter, :reward_status_filter, :teachers_filter, :reward_creator_filter, :students_name_option, :teachers_name_option, :sort_by

      def initialize options_in = {}
        super
        @teacher = options_in[:teacher] if options_in[:teacher]
        #Rails.logger.debug("AKT Params initialize options_in: options_in: #{options_in.inspect}") if options_in        
        #Rails.logger.debug("AKT Params initialize options_in: Teacher: #{@teacher.inspect}") if @teacher
        options_in ||= {}
        options = options_in[self.class.to_s.gsub("::",'').tableize] || options_in || {}
        
        [:date_filter, :reward_status_filter, :teachers_filter, :reward_creator_filter, :sort_by, :students_name_option, :teachers_name_option].each do |iv|
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
          [t.name_last_first, t.id]
        end if school
      end

      def reward_creator_filter_options(school = nil)
        school.teachers.order(:last_name, :first_name).collect do |t|
          [t.name_last_first, t.id]
        end if school
      end
      
      def reward_creator_filter_default
        if reward_creator_filter_options
          reward_creator_filter_options[0]
        else
          nil
        end
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