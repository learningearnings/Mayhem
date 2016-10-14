module Reports
  class StudentActivity < Activity
    def person_base_scope
      school.students.includes(:user)
    end

    def people
      startdate = @endpoints ? @endpoints[0] : 10.years.ago
      enddate = @endpoints ? @endpoints[1] : 1.second.from_now
      base_scope = person_base_scope
      potential_filters.each do |filter|
        filter_option = send(filter)
        base_scope = base_scope.send(*filter_option) if filter_option        
      end
      # have to do .select here to get both the object and the sums, counts, etc.
      # have a look at the scope called "with_transactions_between" on person
      base_scope.select("people.*, 
        sum (CASE WHEN plutus_transactions.description = 'Reward Purchase' THEN plutus_amounts.amount
                 ELSE 0
              END) AS total_credits_spent_on_purchase,
        count(plutus_transactions.id) as num_credits,
        spree_users.username as person_username").having("count(distinct plutus_transactions.id) > 0")
    
    end

	  def transaction_filter
	  	#[:where, "plutus_transactions.description ILIKE 'Weekly Credits for%' or plutus_transactions.description ILIKE
          #                     'Credits Earned for %' or plutus_transactions.description ILIKE 'Monthly Credits for%' or plutus_transactions.description IN
	        #                     ('Issue Credits to Student','Issue Printed Credits to Student')"]
	  end

    def generate_row(person)
        startdate = @endpoints ? @endpoints[0] : 10.years.ago
        enddate = @endpoints ? @endpoints[1] : 1.second.from_now
        Reports::Row[
          person: person.name,
          username: person.person_username,
          classroom: person.person_classroom.present? ? person.person_classroom.first.class_name : "No Classroom",
          #classroom: "No Classroom",
          total_credits_received: (number_with_precision(person.otu_codes.total_credits_received(startdate, enddate).first.sum_of_credits_received, precision: 2, delimiter: ',') || 0),
          total_credits_deposited: (number_with_precision(person.otu_codes.total_credits_deposited(startdate, enddate).first.sum_of_credits_deposited, precision: 2, delimiter: ',') || 0),
          total_credits_spent_on_purchase: (number_with_precision(person.total_credits_spent_on_purchase, precision: 2, delimiter: ',') || 0),
          num_credits: person.otu_codes.total_credits_received(startdate, enddate).first.num_credits,
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
        total_credits_received: "Total Credits Received",
        total_credits_deposited: "Total Credits Deposited",
        total_credits_spent_on_purchase: "Total Credits Spent On Purchase",
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
        total_credits_received: "",
        total_credits_deposited: "",
        total_credits_spent_on_purchase: "",
        num_credits: "",
        account_balance: "",
        num_of_logins: "",
        last_sign_in_at: ""
      }
    end
  end
end
