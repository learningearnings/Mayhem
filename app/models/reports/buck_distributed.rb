module Reports
  class BuckDistributed < Reports::Base
    include ActionView::Helpers::NumberHelper
    #include DateFilterable

    attr_accessor :parameters
    attr_reader :school, :data, :endpoints

    def initialize params
      @parameters = Reports::BuckDistributed::Params.new(params)
      @school = params[:school]
      @data   = []
      @endpoints = date_endpoints(@parameters)
      @school_monthly_credits = school_monthly_credits
    end

    def execute!
      # get recent line items from the school
      teacher_credits.each do |teacher_credit|
        @data << generate_row(teacher_credit)
      end
    end

    # Will include date_filter, reward_status_filter(delivered, undelivered) and teachers_filter
    # Only Date Filter for now.
    def potential_filters
      [:date_filter, :sort_by]
    end

    def school_potential_filters
      [:date_filter]
    end

    def school_monthly_credits
      school_monthly_credits = @school.school_credits.select("SUM(amount) AS total_credit_amount")
      school_potential_filters.each do |filter|
        filter_option = send(filter)
        school_monthly_credits = school_monthly_credits.send(*filter_option) if filter_option        
      end
      school_monthly_credits
    end

    # Override what the date filter filters on
    def date_filter
      case @endpoints
      when nil
        [:credits_created_at, 10.years.ago,1.second.from_now]
      else
        [:credits_created_at, @endpoints[0],@endpoints[1]]
      end
    end
    
    def teacher_credits
      base_scope = buck_distributor_base
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

    def buck_distributor_base
      teacher_credits =  @school.teacher_credits
    end

    def generate_row(teacher_credit)
      {
        id: teacher_credit.id,
        school_id:   teacher_credit.school.id,
        teacher_id:  teacher_credit.teacher.id,
        teacher_name: teacher_credit.teacher.name,
        district_guid: teacher_credit.district_guid,
        amount: (number_with_precision(teacher_credit.amount, precision: 2, delimiter: ',') || 0),
        credit_source: teacher_credit.credit_source,
        reason: teacher_credit.reason,
        created_date: teacher_credit.created_at
       }
    end

    def headers
      {
        id: "Id",
        school_id:   "School Id",
        teacher_id:  "Teacher Id",
        teacher_name: "Teacher Name",
        district_guid: "District Guid",
        amount: "Awarded Amount",
        credit_source: "Credit Source",
        reason: "Reason",
        created_date: "Date"
      }
    end
    
    def date_endpoints parameters = nil
      local_date_filter = parameters.date_filter if parameters && parameters.date_filter
      local_date_filter = @date_filter if !@date_filter.nil?
      [local_date_filter.to_date.beginning_of_month, local_date_filter.to_date.end_of_month]
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

      def date_filter_options
        months = []
        months << [Date.today.strftime("%B %Y"), Date.today.beginning_of_month]
        (1..11).map do |m|
          months << [m.months.ago.strftime("%B %Y"), m.months.ago.beginning_of_month.to_date]
        end     
        months
      end

      def date_filter_default
        date_filter_options[0][1]
      end

    end

  end
end