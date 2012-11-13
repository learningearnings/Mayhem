module Reports
  class Activity < Reports::Base
    include DateFilterable
    include ActionView::Helpers

    def initialize params
      super
      @school = params[:school]
      @date_filter = params[:activity_report][:date_filter] if params[:activity_report]
      @sort_by_filter = params[:activity_report][:sort_by] if params[:activity_report]
      @endpoints = date_endpoints ? [date_endpoints[0],date_endpoints[1]] : nil
    end

    def execute!
      people.each do |person|
        @data << generate_row(person)
      end
    end

    def range
      "From #{l @endpoints[0]} to #{l @endpoints[1]}"
    end


    # Override what the date filter filters on
    def date_filter
      case @endpoints
      when nil
        [:scoped]
      else
       [:where, {@object => { @column =>  @endpoints[0]..@endpoints[1] } }]
      end
    end

    # Will include date_filter, reward_status_filter(delivered, undelivered) and teachers_filter
    # Only Date Filter for now.
    def potential_filters
      [:date_filter, :sort_by]
    end

    def sort_by
      case @sort_by_filter
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
      @object = :transaction
      @column = :created_at
      filter_option = send(:date_filter)
      debits_base_scope = debits_base_scope.send(*filter_option) # if filter_option
      credits_base_scope = credits_base_scope.send(*filter_option) # if filter_option

#      date_filter_options = date_filter(:plutus_transactions,:created_at)
#      date_scoped = send(date_filter_options)
#      debits = person.primary_account.debit_amounts.joins(:transaction).date_scoped.sum(:amount)
#      credits = person.primary_account.credit_amounts.joins(:transaction).date_scoped.sum(:amount)
      debits = debits_base_scope.sum(:amount)
      credits = credits_base_scope.sum(:amount)
      debits - credits
    end


    def people
      base_scope = person_base_scope
      @object = :transaction
      @column = :created_at
      potential_filters.each do |filter|
        filter_option = send(filter)
        base_scope = base_scope.send(*filter_option) if filter_option && filter != :date_filter
      end
      base_scope
    end

    def activity_debits_base_scope(person)
      person.primary_account.debit_amounts.joins(:transaction)
    end

    def activity_credits_base_scope(person)
      person.primary_account.credit_amounts.joins(:transaction)
    end



    def person_base_scope
#      @school.persons.joins(:user).where("spree_users.last_sign_in_at IS NOT NULL")

#      @school.persons.uniq
#        .includes(:user)
#        .includes(:person_school_links)
#        .includes(:plutus_accounts)
#        .joins(:plutus_transactions)
#        .joins(:person_account_links)
#        .where("person_account_links.is_main_account" => true)
#        .where("person_account_links.plutus_account_id" => Plutus::Account.includes(:transaction).includes(:accounts).select("plutus_accounts.id"))


      @school.persons.uniq
        .includes(:user)
        .joins(:person_school_links)
        .joins(:plutus_transactions)
        .joins(:person_account_links)
        .where("person_account_links.is_main_account" => true)
        .where("person_account_links.plutus_account_id" => Plutus::Account.includes(:transaction).includes(:accounts).select("plutus_accounts.id"))
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
  end
end
