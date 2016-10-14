module Reports
  class TeacherActivity < Activity
    def person_base_scope
      school.teachers.includes(:user)
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


    def transaction_filter
    	[:where, "plutus_amounts.type = 'Plutus::DebitAmount' and plutus_transactions.description IN
                               ('Transfer Credits to Teacher',
                                'Issue Credits to Teacher', 'Issue Monthly Credits to Teacher')"]
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
          account_balance: (number_with_precision(person.main_account(@school).balance, precision: 2, delimiter: ',') || 0),
          type: person.type,
          num_of_logins: person.is_a?(Student) ? person.interactions.student_login_between(startdate, enddate).count :  person.interactions.staff_login_between(startdate, enddate).count,
          last_sign_in_at: (person.last_sign_in_at)?time_ago_in_words(person.last_sign_in_at) + " ago":""
        ]
    end

    def headers
      {
        person: "Person",
        username: "Username",
        classroom: "Classroom",
        type: "Type",
        account_activity: "Credits Awarded",
        num_credits: "Num of Credits Awarded",
        account_balance: "Account Balance",
        num_of_logins: "Num of Logins",
        last_sign_in_at: "Last Sign In"
      }
    end
    def data_classes
      {
        person: "",
        username: "",
        classroom: "",
        type: "",
        account_activity: "currency",
        num_credits: "",
        account_balance: "",
        num_of_logins: "",
        last_sign_in_at: ""
      }
    end


  end
end
