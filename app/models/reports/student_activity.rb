module Reports
  class StudentActivity < Activity

    def people
      if @endpoints
        fromStr = @endpoints[0].strftime("%m/%d/%Y")
      else
        fromStr = "01/01/2000"
      end
      crfrom = ""
      crand = ""
      if !@classroom.blank?
        crfrom = " person_school_classroom_links pscl,  "
        crand = " AND pscl.person_school_link_id = psl.id and pscl.classroom_id = #{@classroom} "
      end
      sql = %Q(
        select p.*, u.username as person_username, 
        max(i.created_at) as last_sign_in,
        sum (
          CASE
             WHEN pt.description IN
                     ('Issue Printed Credits to Student',
                      'Issue Credits to Student')
             THEN
                pa.amount
             WHEN pt.description ILIKE
                     'Credits Earned for %'
             THEN
                pa.amount
             WHEN pt.description ILIKE
                     'Weekly Credits for%'
             THEN
                pa.amount
             WHEN pt.description ILIKE
                     'Monthly Credits for%'
             THEN
                pa.amount
             ELSE
                0
          END)
          AS total_credits_deposited,
       sum (
          CASE
             WHEN pt.description = 'Reward Purchase' THEN pa.amount
             ELSE 0
          END)
          AS total_credits_spent_on_purchase,
       sum (
          CASE
             WHEN pt.description = 'Reward Refund' THEN pa.amount
             ELSE 0
          END)
          AS total_credits_refunded,
       sum (
          CASE
             WHEN pt.description IN
                     ('Issue Printed Credits to Student',
                      'Issue Credits to Student')
             THEN
                pa.amount
             ELSE
                0
          END)
          AS credits_awarded_by_teacher,
       sum (CASE
               WHEN pt.description ILIKE
                       'Weekly Credits for%'
               THEN
                  pa.amount
               WHEN pt.description ILIKE
                       'Monthly Credits for%'
               THEN
                  pa.amount
               ELSE
                  0
            END)
          AS credits_awarded_by_system,
        count(i.id) as num_logins
        from people p, spree_users u, person_school_links psl, interactions i,
                 #{crfrom}
                 plutus_transactions pt,
                 plutus_amounts pa,
                 person_account_links pal
        where p.id = psl.person_id and psl.school_id = #{school.id} and u.person_id = p.id
                 #{crand}
                 AND pa.transaction_id = pt.id
                 AND pa.account_id = pal.plutus_account_id
                 AND pal.person_school_link_id = psl.id
          and p.status = 'active' and psl.status = 'active' and p.type in ('Student')
          and i.person_id = p.id and i.page in ('/students/home','/mobile/v1/students/auth')
          and i.created_at >= \'#{fromStr}\'
          and pt.created_at >= \'#{fromStr}\'
        group by p.id, psl.id, u.username
      )
      if sort_by.size > 1
        sql = sql + " order by #{sort_by[1]} " 
      end
      students = Student.find_by_sql(sql)
      students
    end

    def generate_row(person)
        startdate = @endpoints ? @endpoints[0] : 10.years.ago
        enddate = @endpoints ? @endpoints[1] : 1.second.from_now
        Reports::Row[
          person: person.name,
          username: person.person_username,
          grade: person.grade,
          total_credits_awarded_by_teacher: (number_with_precision(person.credits_awarded_by_teacher, precision: 2, delimiter: ',') || 0),
          total_credits_awarded_by_system: (number_with_precision(person.credits_awarded_by_system, precision: 2, delimiter: ',') || 0),
          total_credits_refunded: (number_with_precision(person.total_credits_refunded, precision: 2, delimiter: ',') || 0),
          total_credits_deposited: (number_with_precision(person.total_credits_deposited, precision: 2, delimiter: ',') || 0),
          total_credits_spent_on_purchase: (number_with_precision(person.total_credits_spent_on_purchase, precision: 2, delimiter: ',') || 0),
          account_balance: (number_with_precision(person.main_account(@school).balance, precision: 2, delimiter: ',') || 0),
          num_of_logins: person.num_logins,
          last_sign_in_at: (person.last_sign_in)?time_ago_in_words(person.last_sign_in) + " ago":""
        ]
    end

    def headers
      {
        person: "Person",
        username: "Username",
        grade: "Grade",
        total_credits_awarded_by_teacher: "Total Credits Awarded By Teacher",
        total_credits_awarded_by_system: "Total Credits Awarded By System",
        total_credits_awarded_by_refunded: "Total Credits Refunded",                
        total_credits_deposited: "Total Credits Deposited",
        total_credits_spent_on_purchase: "Total Credits Spent On Purchases",
        account_balance: "Current Account Balance",
        num_of_logins: "Num of Logins",
        last_sign_in_at: "Last Sign In"
      }
    end
    def data_classes
      {
        person: "",
        username: "",       
        grade: "",
        total_credits_awarded_by_teacher: "",
        total_credits_awarded_by_system: "",
        total_credits_awarded_by_refunded: "",                
        total_credits_deposited: "",
        total_credits_spent_on_purchase: "",
        account_balance: "",
        num_of_logins: "",
        last_sign_in_at: ""
      }
    end
  end
end
