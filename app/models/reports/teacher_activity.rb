module Reports
  class TeacherActivity < Activity
    def person_base_scope
      school.teachers.includes(:user)
    end

    def people
      if @endpoints
        fromStr = @endpoints[0].strftime("%m/%d/%Y")
      else
        fromStr = "01/01/2000"
      end
      sql = %Q(
        select p.*, u.username as person_username, 
        max(i.created_at) as last_sign_in,
        (select sum(oc.points) from otu_codes oc
         where oc.person_school_link_id = psl.id
           and oc.created_at > \'#{fromStr}\' ) as issued_balance,
        (select count(oc.id) from otu_codes oc
         where oc.person_school_link_id = psl.id
           and oc.created_at > \'#{fromStr}\' ) as num_credits,
        count(i.id) as num_logins,
        (CASE
                     WHEN (SELECT count (*)
                             FROM person_school_classroom_links pscl
                            WHERE pscl.person_school_link_id = psl.id) > 0
                     THEN
                        'Y'
                     ELSE
                        'N'
                  END)
                    AS has_classroom
        from people p, spree_users u, person_school_links psl, interactions i
        where p.id = psl.person_id and psl.school_id = #{school.id} and u.person_id = p.id
          and p.status = 'active' and psl.status = 'active' and p.type in ('Teacher','SchoolAdmin')
          and i.person_id = p.id and i.page in ('/teachers/home','/mobile/v1/teachers/auth','/sti/give_credits')
          and i.created_at >= \'#{fromStr}\'
        group by p.id, psl.id, u.username, u.last_sign_in_at
      )
      if sort_by.size > 1
        sql = sql + " order by #{sort_by[1]} " 
      end
      teachers = Teacher.find_by_sql(sql)
      teachers
    end

    def generate_row(person)
        startdate = @endpoints ? @endpoints[0] : 10.years.ago
        enddate = @endpoints ? @endpoints[1] : 1.second.from_now
        Reports::Row[
          person: person.name,
          username: person.person_username,
          classroom: person.has_classroom,
          issued_balance: (number_with_precision(person.issued_balance, precision: 2, delimiter: ',') || 0),
          num_credits: person.num_credits,
          account_balance: (number_with_precision(person.main_account(@school).balance, precision: 2, delimiter: ',') || 0),
          type: person.type,
          num_of_logins: person.num_logins,
          last_sign_in_at: (person.last_sign_in)?time_ago_in_words(person.last_sign_in) + " ago":""
        ]
    end

    def headers
      {
        person: "Person",
        username: "Username",
        classroom: "Has Classroom",
        type: "Type",
        issued_balance: "Total Credits Issued",
        num_credits: "Num of Credits Issued Txns",        
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
        issued_balance: "currency",
        num_credits: "",
        account_balance: "",
        num_of_logins: "",
        last_sign_in_at: ""
      }
    end


  end
end
