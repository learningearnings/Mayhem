module Reports
  class Activity < Reports::Base
    include DateFilterable
    include ActionView::Helpers

    attr_accessor :parameters
    def initialize params
      super
      @school = params[:school]
#      @sort_by_filter = params[:reports_activity_params][:sort_by] if params[:reports_activity_params]
      @endpoints = date_endpoints ? [date_endpoints[0],date_endpoints[1]] : nil
      @parameters = Reports::Activity::Params.new(params)
      @data = []
    end

    def data
      @data
    end

    def execute!
      people.each do |person|
        @data << generate_row(person)
      end
    end

    def range
      @endpoints ? "From #{l @endpoints[0]} to #{l @endpoints[1]}" : nil
    end


    # Override what the date filter filters on
    def date_filter
      case @endpoints
      when nil
        [:scoped]
      else
       [:where, {:plutus_transactions => { :created_at =>  @endpoints[0]..@endpoints[1] } }]
      end
    end

    # Will include date_filter, reward_status_filter(delivered, undelivered) and teachers_filter
    # Only Date Filter for now.
    def potential_filters
      [:date_filter, :sort_by]
    end

    def sort_by
      case parameters.sort_by_filter
      when "Default"
        [:scoped]
      when "First, Last"
        [:order, "people.first_name, people.last_name"]
      when "Last, First"
        [:order, "people.last_name, people.first_name"]
      when "Username"
        [:order, "spree_users.username"]
      end
    end

    def activity_balance(person)
      debits_base_scope = activity_debits_base_scope(person)
      credits_base_scope = activity_credits_base_scope(person)
      filter_option = send(:date_filter)
      debits_base_scope = debits_base_scope.send(*filter_option) # if filter_option
      credits_base_scope = credits_base_scope.send(*filter_option) # if filter_option
      debits = debits_base_scope.sum(:amount)
      credits = credits_base_scope.sum(:amount)
      debits - credits
    end


    def people
      base_scope = person_base_scope
      Rails.logger.info base_scope.to_sql
      potential_filters.each do |filter|
        filter_option = send(filter)
        base_scope = base_scope.send(*filter_option) if filter_option
      end
      Rails.logger.info base_scope.to_sql
      base_scope
    end

    def activity_debits_base_scope(person)
      person.primary_account.debit_amounts.joins(:transaction)
    end

    def activity_credits_base_scope(person)
      person.primary_account.credit_amounts.joins(:transaction)
    end



    def person_base_scope
      @school.students.uniq
        .includes(:user)
        .joins(:person_school_links)
        .joins(:plutus_transactions)
        .joins(:person_account_links)
        .where("person_account_links.is_main_account" => true)
#        .where("person_account_links.plutus_account_id" => Plutus::Account.includes(:transaction).includes(:accounts).select("plutus_accounts.id"))
    end

    def generate_row(person)
      Reports::Row[
        person: person,
        username: person.user.username,
        account_activity: number_to_currency(activity_balance(person),:format => "%n", :negative_format => "(%n)"),
        type: person.type,
        last_sign_in_at: time_ago_in_words(person.user.last_sign_in_at) + " ago"
      ]
    end

    def headers
      {
        person: "Person",
        username: "Username",
        type: "Type",
        last_sign_in_at: "Last Sign In",
        account_activity: "Account Activity"
      }
    end
    def data_classes
      {
        person: "",
        username: "",
        type: "",
        last_sign_in_at: "",
        account_activity: "currency"
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
        date_filter_options[0][1]
      end

    end
  end
end
