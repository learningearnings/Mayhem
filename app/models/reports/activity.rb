module Reports
  class Activity < Reports::Base
    include DateFilterable
    include ActionView::Helpers

    def initialize params
      super
      @school = params[:school]
      @date_filter = params[:date_filter]
      @sort_by_filter = params[:sort_by]
    end

    def execute!
      people.each do |person|
        @data << generate_row(person)
      end
    end

    # Override what the date filter filters on
    def date_filter
      case date_endpoints
      when nil
        [:scoped]
      else
        [:where, {user: { last_sign_in_at: date_endpoints[0]..date_endpoints[1] } }]
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
        [:order, "people.username"]
      end
    end

    def people
      base_scope = person_base_scope
      potential_filters.each do |filter|
        filter_option = send(filter)
        base_scope = base_scope.send(*filter_option) if filter_option
      end
      base_scope
    end

    def person_base_scope
      Person.includes([:user, :person_school_links]).where("spree_users.last_sign_in_at IS NOT NULL").where(person_school_links: { school_id: @school.id })
    end

    def generate_row(person)
      user = person.user
      Reports::Row[
        person: person,
        username: user.username,
        credit_balance: number_to_currency(person.primary_account.balance),
        type: person.type,
        last_sign_in_at: user.last_sign_in_at
      ]
    end

    def headers
      {
        person: "Person",
        username: "Username",
        type: "Type",
        last_sign_in_at: "Last Sign In",
        credit_balance: "Credit Balance"
      }
    end
  end
end
