module Reports
  class StudentActivity < Activity

    def people
      if @endpoints
        fromStr = @endpoints[0].strftime("%m/%d/%Y")
      else
        fromStr =  (Date.today - 365).strftime("%m/%d/%Y")
      end
      crfrom = ""
      crand = ""
      if !@classroom.blank?
        crfrom = " person_school_classroom_links pscl,  "
        crand = " AND pscl.person_school_link_id = psl.id and pscl.classroom_id = #{@classroom} "
      end

      sql1 =  %Q(
        select p.*,
        u.username as person_username,
        u.last_sign_in_at as last_sign_in,
        0 AS total_credits_deposited,
        0 AS total_credits_spent_on_purchase,
        0 AS total_credits_refunded,
        0 AS credits_awarded_by_teacher,
        0 AS credits_awarded_by_system,
        0 as num_logins,
        0 as total_transactions,
        'Y' as has_activity
        from people p, spree_users u,  #{crfrom} person_school_links psl
        where p.id = u.person_id and p.id = psl.person_id and psl.school_id = #{school.id}
          and p.status = 'active' and psl.status = 'active' and p.type in ('Student') #{crand}
      )
      if sort_by.size > 1
        sql1 = sql1 + " order by #{sort_by[1]} "
      else
        sql1 = sql1 + " order by p.grade, p.last_name, p.first_name "
      end
      students = Student.find_by_sql(sql1)

      sql2 = %Q(
        select
        p.id as person_id,
        max(i.created_at) as last_sign_in,
        count(i.id) as num_logins
        from interactions i, people p, person_school_links psl
        where p.id = psl.person_id and psl.school_id = #{school.id}
         and p.status = 'active' and psl.status = 'active' and p.type in ('Student')
          and i.person_id = p.id and i.page in ('/students/home','/mobile/v1/students/auth')
          and i.created_at >= \'#{fromStr}\'
        group by p.id
      )
      interactions = Interaction.find_by_sql(sql2)

      sql3 = %Q(
        select p.id as person_id,
        count(pt.id) as total_transactions,
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
             WHEN pt.description =  'Reward Refund'
             THEN pa.amount
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
          AS credits_awarded_by_system
        from people p, person_school_links psl,
                 plutus_transactions pt,
                 plutus_amounts pa,
                 person_account_links pal
        where p.id = psl.person_id and psl.school_id = #{school.id}
          and p.status = 'active' and psl.status = 'active' and p.type in ('Student')
          AND pa.transaction_id = pt.id
          AND pa.account_id = pal.plutus_account_id
          AND pal.person_school_link_id = psl.id
          and pt.created_at >= \'#{fromStr}\'
        group by p.id
      )
      transactions = Plutus::Transaction.find_by_sql(sql3)
      students.each do | stud |

        i = interactions.detect { | int | int.person_id.to_i == stud.id.to_i }
        t = transactions.detect { | txn | txn.person_id.to_i == stud.id.to_i }
        stud.has_activity = "N" if !(i or t)
        if i
          stud.num_logins = i.num_logins
          stud.last_sign_in = i.last_sign_in.present? ? i.last_sign_in : nil
        else
          stud.last_sign_in = nil
        end
        if t
          stud.total_credits_deposited = t.total_credits_deposited
          stud.total_credits_spent_on_purchase = t.total_credits_spent_on_purchase
          stud.total_credits_refunded = t.total_credits_refunded
          stud.credits_awarded_by_teacher = t.credits_awarded_by_teacher
          stud.credits_awarded_by_system = t.credits_awarded_by_system
          stud.total_transactions = t.total_transactions
        end
      end
      students = students.reject{ | stud | (stud.has_activity == "N" or (stud.total_transactions == 0 and stud.num_logins == 0))}
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
          num_of_logins: person.num_logins,
          last_sign_in_at: (person.last_sign_in)?time_ago_in_words(person.last_sign_in) + " ago":"",
          account_balance: (number_with_precision(person.main_account(@school).balance, precision: 2, delimiter: ',') || 0),

        ]
    end

    def headers
      {
        person: "Person",
        username: "Username",
        grade: "Grade",
        total_credits_awarded_by_teacher: "Total Credits Awarded By Teacher",
        total_credits_awarded_by_system: "Total Credits Awarded By System",
        total_credits_refunded: "Total Credits Refunded",
        total_credits_deposited: "Total Credits Deposited",
        total_credits_spent_on_purchase: "Total Credits Spent On Purchases",
        num_of_logins: "Num of Logins",
        last_sign_in_at: "Last Sign In",
        account_balance: "Current Account Balance"
      }
    end
    def data_classes
      {
        person: "",
        username: "",
        grade: "",
        total_credits_awarded_by_teacher: "",
        total_credits_awarded_by_system: "",
        total_credits_refunded: "",
        total_credits_deposited: "",
        total_credits_spent_on_purchase: "",
        num_of_logins: "",
        last_sign_in_at: "",
        account_balance: ""
      }
    end
  end
end
