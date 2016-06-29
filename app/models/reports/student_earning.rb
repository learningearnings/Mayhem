module Reports
  class StudentEarning < Reports::Base
    include ActionView::Helpers::NumberHelper
    include DateFilterable

    attr_accessor :parameters
    attr_reader :school, :data, :endpoints

    def initialize params
      @parameters = Reports::StudentEarning::Params.new(params)
      @school = params[:school]
      @data   = []
      @endpoints = date_endpoints(@parameters)
      @classroom = params[:classroom_filter]
      @logged_in_person = params[:logged_in_person]
    end

    def execute!
      # get recent line items from the school
      students.each do |student|
        @data << generate_row(student)
      end
    end

    # Will include date_filter, reward_status_filter(delivered, undelivered) and teachers_filter
    # Only Date Filter for now.
    def potential_filters
      [:date_filter,:classroom_filter, :sort_by]
    end

    # Override what the date filter filters on
    def date_filter
      case @endpoints
      when nil
        [:with_credits_between, 10.years.ago,1.second.from_now]
      else
        [:with_credits_between, @endpoints[0],@endpoints[1]]
      end
    end

    def classroom_filter
      if @classroom.present?
        [:person_with_classroom,  @classroom]
      end
    end

    def students
      base_scope = students_earning_base
      potential_filters.each do |filter|
        filter_option = send(filter)
        base_scope = base_scope.send(*filter_option) if filter_option        
      end
      base_scope
    end

    def sort_by
      case parameters.sort_by
      when "Default"
        [:scoped]
      when "First, Last"
        [:order, "people.first_name, people.last_name"]
      when "Last, First"
        [:order, "people.last_name, people.first_name"]
      when "Username"
        [:order, "user_name"]
      end
    end

    def students_earning_base
        # First, get teacher's classrooms for this school
      student_earning =  @school.students.joins(:spree_user).joins(:person_school_links).joins(:otu_codes).select("people.id,people.first_name,people.last_name,spree_users.username AS user_name, SUM(otu_codes.points) AS total_credits, SUM(case when otu_codes.active = false then otu_codes.points else null end) AS total_deposited, SUM(case when otu_codes.active = true then otu_codes.points else null end) AS total_undeposited").group("people.id,people.first_name, people.last_name, user_name")
    end


    def generate_row(student)
      {
        id: student.id,
        student_name:   student.name,
        username:  student.user_name,
        classroom: student.person_classroom.present? ? get_student_classroom(student) : "No Classroom",
        total_credits: (number_with_precision(student.total_credits, precision: 2, delimiter: ',') || 0),
        total_deposited: (number_with_precision(student.total_deposited, precision: 2, delimiter: ',') || 0),
        total_undeposited: (number_with_precision(student.total_undeposited, precision: 2, delimiter: ',') || 0)
       }
    end

    def get_student_classroom(student)
      student_classrooms_array = student.person_classroom.map{|c| c.class_name}
      logged_in_user_classroom_array = @logged_in_person.classrooms_for_school(@school).map{|c| c.name}
      match_classroom = student_classrooms_array & logged_in_user_classroom_array
      if match_classroom.present?
        match_classroom.first
      else
        student_classrooms_array.first
      end  
    end

    def headers
      {
        id: "Id",
        student_name:   "Student",
        username:  "Username",
        classroom:  "Classroom",
        total_credits: "Total Credits",
        total_deposited: "Total Deposited",
        total_undeposited: "Total Undeposited"
      }
    end
    def date_endpoints parameters = nil
      local_date_filter = parameters.date_filter if parameters && parameters.date_filter
      local_date_filter = @date_filter if !@date_filter.nil?
      case local_date_filter
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
        [10.years.ago,1.second.from_now]
      end
    end
      
    class Params < Reports::ParamsBase
      attr_accessor :date_filter,:sort_by
      def initialize options_in = {}
        options_in ||= {}
        options = options_in[self.class.to_s.gsub("::",'').tableize] || options_in || {}
        [:date_filter, :sort_by].each do |iv|
          default_method = (iv.to_s + "_default").to_sym
          default_value = nil
          default_value = send(default_method) if respond_to? default_method
          instance_variable_set(('@' + iv.to_s).to_sym,options[iv] || default_value || "")
        end
      end

      def sort_by_default
        sort_by_options[0]
      end

      def sort_by_options
        ["Default", "First, Last", "Last, First", "Username"]
      end

      def date_filter_default
        date_filter_options[4][1]
      end

    end

  end
end