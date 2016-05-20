module Reports
  class StudentEarning < Reports::Base
    include ActionView::Helpers::NumberHelper
    include DateFilterable

    attr_accessor :parameters
    attr_reader :school, :data

    def initialize params
      @parameters = Reports::Activity::Params.new(params)
      @school = params[:school]
      @data   = []
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
      [:date_filter]
    end

    # Override what the date filter filters on
    def date_filter
      case @endpoints
      when nil
        [:with_transactions_between, 30.days.ago,1.second.from_now]
      else
        [:with_transactions_between, @endpoints[0],@endpoints[1]]
      end
    end

    def students
      base = students_earning_base
      #potential_filters.each do |filter|
      #  base = send(filter, base) || []
      #end
      base
    end

    def sort_by_filter(base)
      case @sort_by_filter
      when "First, Last"
        base.sort_by {|student| "#{student.first_name}, #{student.last_name}"}
      when "Last, First"
        base.sort_by {|student| "#{student.last_name}, #{student.first_name}"}
      when "Username"
        base.sort_by {|student| student.user.username }
      else
        base
      end
    end

    def students_earning_base
        # First, get teacher's classrooms for this school
      bucket =  @school.students.joins(:person_school_links).joins(:otu_codes).where("otu_codes.created_at >= '2016-05-17' AND otu_codes.created_at <= '2016-05-21'").select("people.*, SUM(otu_codes.points) AS total_credits")
    end


    def generate_row(student)
      {
        student_name:   student.name,
        username:  student.user.username,
        total_credits: (number_with_precision(student.total_credits, precision: 2, delimiter: ',') || 0)
        #credit_amount: (number_with_precision(student.savings_balance, precision: 2, delimiter: ',') || 0)
       }
    end

    def headers
      {
        student_name:   "Student",
        username:  "Username",
        total_credits: "Total Credits"
        #checking_balance: "Checking Balance",
        #savings_balance: "Savings Balance"
      }
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
        date_filter_options[7][1]
      end

    end

  end
end