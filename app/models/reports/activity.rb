module Reports
  class Activity < Reports::Base
    include DateFilterable
    include ActionView::Helpers

    attr_accessor :parameters
    attr_reader :school, :data
    def initialize params
      super
      @parameters = Reports::Activity::Params.new(params)
      @school = params[:school]
      @endpoints = date_endpoints(@parameters);
      @classroom = params[:classroom_filter]
      @logged_in_person = params[:logged_in_person]
      @data = []
    end

    def execute!
      begin
        people.each do |person|
          @data << generate_row(person) if person_with_classroom_filter(person)
        end
      rescue StandardError => e
        Rails.logger.fatal("Something went bad wrong")
        Rails.logger.fatal(e.to_s + people.to_yaml)
      rescue NoMethodError => e
        Rails.logger.fatal("Something went bad wrong")
        Rails.logger.fatal(e.to_s + people.to_yaml)
      end
    end

    def range
      @endpoints ? "From #{l @endpoints[0]} to #{l @endpoints[1]}" : nil
    end

    def person_with_classroom_filter(person)
      student_classrooms_array = person.person_classroom_name
      logged_in_user_classroom_array = @logged_in_person.classrooms_for_school(@school).map{|c| c.name}
      intersection_array = student_classrooms_array & logged_in_user_classroom_array
      if @classroom.present?
        if intersection_array.size > 1 && @logged_in_person.classrooms_for_school(@school).map{|c| c.name if c.id == @classroom.to_i}.include?(student_classrooms_array.first)
          return true
        elsif intersection_array.size <= 1 && intersection_array.first == student_classrooms_array.first
          return true
        end
      else
        return true
      end  
    end

    # Override what the date filter filters on
    def date_filter
      case @endpoints
      when nil
        [:with_transactions_between, 10.years.ago,1.second.from_now]
      else
        [:with_transactions_between, @endpoints[0],@endpoints[1]]
      end
    end

    def classroom_filter
      if @classroom.present?
        [:person_with_classroom,  @classroom]
      end
    end

    # Will include date_filter, reward_status_filter(delivered, undelivered) and teachers_filter
    # Only Date Filter for now.
    def potential_filters
      [:transaction_filter, :date_filter, :classroom_filter, :sort_by]
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
        [:order, "person_username"]
      end
    end

    def people
      base_scope = person_base_scope
      potential_filters.each do |filter|
        filter_option = send(filter)
        base_scope = base_scope.send(*filter_option) if filter_option        
      end
      # have to do .select here to get both the object and the sums, counts, etc.
      # have a look at the scope called "with_transactions_between" on person
      base_scope.select("people.*, 
        sum(plutus_amounts.amount) as activity_balance,
        count(plutus_transactions.id) as num_credits,
        spree_users.username as person_username").having("count(distinct plutus_transactions.id) > 0")
    end
    
    def activity_debits_base_scope(person)
      person.primary_account.debit_amounts.joins(:transaction)
    end

    def activity_credits_base_scope(person)
      person.primary_account.credit_amounts.joins(:transaction)
    end

    def generate_row(person)
        startdate = @endpoints ? @endpoints[0] : 10.years.ago
        enddate = @endpoints ? @endpoints[1] : 1.second.from_now
        Reports::Row[
          person: person.name,
          username: person.person_username,
          classroom: person.person_classroom.present? ? person.person_classroom.first.class_name : "No Classroom",
          #classroom: "No Classroom",
          account_activity: (number_with_precision(person.activity_balance, precision: 2, delimiter: ',') || 0),
          num_credits: person.num_credits,
          type: person.type,
          num_of_logins: person.is_a?(Student) ? person.interactions.student_login_between(startdate, enddate).count :  person.interactions.staff_login_between(startdate, enddate).count 
        ]
    end

    def headers
      {
        person: "Person",
        username: "Username",
        classroom: "Classroom",
        type: "Type",
        num_of_logins: "Num of Logins",
        account_activity: "Credits Awarded",
        num_credits: "Num of Credits Awarded"
      }
    end
    def data_classes
      {
        person: "",
        username: "",
        classroom: "",
        type: "",
        num_of_logins: "",
        account_activity: "currency",
        num_credits: ""
      }
    end

    class Params < Reports::ParamsBase
      attr_accessor :date_filter,:sort_by, :classroom_filter
      def initialize options_in = {}
        options_in ||= {}
        options = options_in[self.class.to_s.gsub("::",'').tableize] || options_in || {}
        [:date_filter, :sort_by, :classroom_filter].each do |iv|
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
