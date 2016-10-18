module Reports
  class TeacherActivity < Activity
    def person_base_scope
      school.teachers.includes(:user)
    end

    def people
      if @endpoints
        fromStr = @endpoints[0].strftime("%m/%d/%Y")
      else
        fromStr =  (Date.today - 365).strftime("%m/%d/%Y")
      end
      sql1 =  %Q(
        select p.*, 
        u.username as person_username, 
        u.last_sign_in_at as last_sign_in,
        NULL as last_sign_in,
        0 as issued_balance,
        0 as num_credits,
        0 as num_logins,
        (CASE
                     WHEN (SELECT count (*)
                             FROM person_school_classroom_links pscl
                            WHERE pscl.person_school_link_id = psl.id) > 0
                     THEN
                        'Y'
                     ELSE
                        'N'
                  END)
                    AS has_classroom,
        'Y' as has_activity
        from people p, spree_users u, person_school_links psl
        where p.id = u.person_id and p.id = psl.person_id and psl.school_id = #{school.id} 
          and p.status = 'active' and psl.status = 'active' and p.type in ('Teacher','SchoolAdmin')
      )
      if sort_by.size > 1
        sql1 = sql1 + " order by #{sort_by[1]} " 
      else  
        sql1 = sql1 + " order by p.last_name, p.first_name "  
      end      
      teachers = Teacher.find_by_sql(sql1)  
          
      sql2 = %Q(
        select 
        p.id as person_id,
        max(i.created_at) as last_sign_in,
        count(i.id) as num_logins        
        from interactions i, people p, person_school_links psl
        where p.id = psl.person_id and psl.school_id = #{school.id} 
          and p.status = 'active' and psl.status = 'active' and p.type in ('Teacher','SchoolAdmin')        
          and i.person_id = p.id and i.page in ('/teachers/home','/mobile/v1/teachers/auth','/sti/give_credits')
          and i.created_at >= \'#{fromStr}\'
        group by p.id
      )  
      interactions = Interaction.find_by_sql(sql2)
          
      sql3 = %Q(
        select
        p.id as person_id, 
        sum(oc.points) as issued_balance,
        count(oc.id) as num_credits
        from people p, person_school_links psl, otu_codes oc
        where p.id = psl.person_id and psl.school_id = #{school.id} 
          and p.status = 'active' and psl.status = 'active' and p.type in ('Teacher','SchoolAdmin')
          and oc.person_school_link_id = psl.id and oc.created_at >= \'#{fromStr}\'
        group by p.id
      )
      otu_codes = OtuCode.find_by_sql(sql3)
      
      teachers.each do | teach |
        i = interactions.detect { | int | int.person_id.to_i == teach.id.to_i }
        if i
          teach.num_logins = i.num_logins
          teach.last_sign_in = i.last_sign_in if !i.last_sign_in.blank?
        end
        o = otu_codes.detect { | oc| oc.person_id.to_i == teach.id.to_i }
        if o
          teach.issued_balance = o.issued_balance
          teach.num_credits = o.num_credits
        end
        teach.has_activity = "N" if !(o or i)
      end
      teachers = teachers.reject{ | teach | (teach.has_activity == "N" or (teach.num_logins == 0 and teach.num_credits == 0))}
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
          type: person.type,
          num_of_logins: person.num_logins,
          last_sign_in_at: (person.last_sign_in)?time_ago_in_words(person.last_sign_in) + " ago":"",
          account_balance: (number_with_precision(person.main_account(@school).balance, precision: 2, delimiter: ',') || 0)
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
        num_of_logins: "Num of Logins",
        last_sign_in_at: "Last Sign In",
        account_balance: "Account Balance",        
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
        num_of_logins: "",
        last_sign_in_at: "",
        account_balance: ""        
      }
    end


  end
end
