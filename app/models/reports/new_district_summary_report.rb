module Reports
  class NewDistrictSummaryReport
    
    def initialize options = {}
      if options.has_key?("beginning_day")
        @beginning_day = Time.zone.parse(options["beginning_day"]).beginning_of_day
      else
        @beginning_day = (Time.zone.now - 30.days).beginning_of_day
      end
      if options.has_key?("ending_day")
        @ending_day = Time.zone.parse(options["ending_day"]).end_of_day
      else
        @ending_day = Time.zone.now.end_of_day
      end
      @districts_where = ""
      if options.has_key?("districts") and options["districts"].strip.length > 2
        @districts = options["districts"].downcase.split(",").collect {|x| "'#{x.strip}'"}.join(", ")
        @districts_where = " AND d.guid IN (#{@districts}) "
      else
        @districts = "ALL"        
      end
      @total_days = (@ending_day.to_date - @beginning_day.to_date).to_i
      
      sql = %Q(     
          SELECT d.name,
          d.guid,
          (SELECT count(tp.id)
            FROM people tp, person_school_links tpsl, schools s
            WHERE tpsl.school_id = s.id
              AND s.district_guid = d.guid
              AND tp.type IN ('Teacher','SchoolAdmin')
              AND tpsl.person_id = tp.id
           AND tpsl.status = 'active'
           AND tp.status = 'active') AS teacher_count,
          (SELECT count(DISTINCT p.id)
            FROM people p, person_school_links psl, interactions i, schools s
            WHERE s.id = psl.school_id AND p.id = psl.person_id
              AND (i.page = '/teachers/home' or i.page = '/mobile/v1/teachers/auth' or i.page = '/sti/give_credits')
              AND i.person_id = p.id
              AND s.district_guid = d.guid
              AND p.type IN ('Teacher','SchoolAdmin')
              AND p.status = 'active' AND psl.status = 'active'
                 AND i.created_at >= '#{@beginning_day}'
                 AND i.created_at <=  '#{@ending_day}'
              ) AS teacher_login_count,
          (SELECT count(DISTINCT tcp.id)
           FROM people tcp, person_school_links tcpsl, otu_codes tcoc, plutus_transactions tcpt, schools s
           WHERE s.id = tcpsl.school_id AND tcp.id = tcpsl.person_id
           AND tcoc.person_school_link_id = tcpsl.id 
                     AND s.district_guid = d.guid
           AND tcpt.commercial_document_id  = tcoc.id 
         AND tcpt.commercial_document_type = 'OtuCode' 
         AND tcpt.description ilike '%ebucks for student%'
             AND tcp.type IN ('Teacher','SchoolAdmin')
             AND tcp.status = 'active' AND tcpsl.status = 'active'
                 AND tcoc.created_at >= '#{@beginning_day}'
                 AND tcoc.created_at <=  '#{@ending_day}'
             ) AS teachers_issuing_credits_count,
          (SELECT count(sp.id)
            FROM people sp, person_school_links spsl, schools s
            WHERE spsl.school_id = s.id
              AND sp.type IN ('Student')
                        AND s.district_guid = d.guid
              AND spsl.person_id = sp.id
           AND spsl.status = 'active'
           AND sp.status = 'active') AS student_count,
               (SELECT count(DISTINCT p.id)
            FROM people p, person_school_links psl, interactions i, schools s
            WHERE s.id = psl.school_id AND p.id = psl.person_id
              AND (i.page = '/students/home' or i.page = '/mobile/v1/students/auth')
              AND i.person_id = p.id
              AND s.district_guid = d.guid
              AND p.type IN ('Student')
              AND p.status = 'active' AND psl.status = 'active'
                 AND i.created_at >= '#{@beginning_day}'
                 AND i.created_at <=  '#{@ending_day}'
              ) AS student_login_count,
          (SELECT count(DISTINCT sp.id)
            FROM people sp, person_school_links sppsl, plutus_transactions sppt, plutus_amounts sppa, person_account_links sppal, schools s
            WHERE sppsl.school_id = s.id AND sppsl.person_id = sp.id AND sp.status = 'active' AND sppsl.status = 'active'
             AND sp.type = 'Student'
                       AND s.district_guid = d.guid
             AND sppa.transaction_id = sppt.id
             AND sppa.account_id = sppal.plutus_account_id AND sppal.person_school_link_id = sppsl.id
             AND sppt.description = 'Reward Purchase'
                              AND sppt.created_at >= '#{@beginning_day}'
                 AND sppt.created_at <=  '#{@ending_day}'            
            ) AS students_purchasing_rewards_count,
          (SELECT count(DISTINCT sr.id)
            FROM people sr, person_school_links srpsl, plutus_transactions srpt, plutus_amounts srpa, person_account_links srpal, schools s
            WHERE srpsl.school_id = s.id AND srpsl.person_id = sr.id AND sr.status = 'active' AND srpsl.status = 'active'
             AND sr.type = 'Student'
             AND srpa.transaction_id = srpt.id
                       AND s.district_guid = d.guid
             AND srpa.account_id = srpal.plutus_account_id AND srpal.person_school_link_id = srpsl.id
             AND (srpt.description IN ('Issue Printed Credits to Student','Issue Credits to Student') OR srpt.description ILIKE 'Weekly Credits for%' OR srpt.description ILIKE 'Monthly Credits for%' )
                 AND srpt.created_at >= '#{@beginning_day}'
                 AND srpt.created_at <=  '#{@ending_day}'
            ) AS students_receiving_credits_count,
          (SELECT count(DISTINCT sd.id)
            FROM people sd, person_school_links sdpsl, plutus_transactions sdpt, plutus_amounts sdpa, person_account_links sdpal, schools s
            WHERE sdpsl.school_id = s.id AND sdpsl.person_id = sd.id AND sd.status = 'active' AND sdpsl.status = 'active'
             AND sdpa.transaction_id = sdpt.id
                       AND s.district_guid = d.guid
             AND sd.type = 'Student'
             AND sdpa.account_id = sdpal.plutus_account_id AND sdpal.person_school_link_id = sdpsl.id
             AND (sdpt.description IN ('Issue Printed Credits to Student','Issue Credits to Student') OR sdpt.description ILIKE 'Credits Earned for %')
                              AND sdpt.created_at >= '#{@beginning_day}'
                 AND sdpt.created_at <=  '#{@ending_day}'
            ) AS students_depositing_credits_count
          FROM districts d
          WHERE d.current_staff_version is not null
          #{@districts_where}
      )
      @rows = District.find_by_sql(sql)
      
    end
    
    def run
      csv = CSV.generate do |csv|
        csv << ["District summary report spaning #{@total_days} days from: #{@beginning_day} to: #{@ending_day} for districts: #{@districts}"]

        @rows.each do | row |
          if row.teacher_login_count == 0 or row.teachers_issuing_credits_count == 0
            teacher_engagement = 0.0
          else
            teacher_engagement = (row.teachers_issuing_credits_count.to_f / row.teacher_login_count.to_f) * 100.0
          end
          if row.student_login_count == 0 or row.student_count == 0
            student_login_percent = 0.0
          else
            student_login_percent = (row.student_login_count.to_f / row.student_count.to_f ) * 100.0
          end
          if row.student_login_count == 0 or row.students_depositing_credits_count == 0
            student_deposits_percent = 0.0
          else
            student_deposits_percent = (row.students_depositing_credits_count.to_f / row.student_login_count.to_f ) * 100.0
          end          
          if row.student_login_count == 0 or row.students_purchasing_rewards_count == 0
            student_engagement_percent = 0.0
          else
            student_engagement_percent = (row.students_purchasing_rewards_count.to_f / row.student_login_count.to_f ) * 100.0
          end  
          csv << [""]
          csv << ["District Name","District GUID","Teacher Count","Teacher Logins","Teachers Issueing Credits", 
          "Student Count","Student Logins","Students Receiving Credits","Students Depositing Credits","Students Purchasing Rewards",
          "% of Teacher Enagement","% of Student Logins","% of Login vs Deposits","% of Student Engagement"]                             
          csv << [row.name, row.guid, row.teacher_count, row.teacher_login_count, row.teachers_issuing_credits_count, 
            row.student_count, row.student_login_count, row.students_receiving_credits_count, row.students_depositing_credits_count, row.students_purchasing_rewards_count,
            teacher_engagement, student_login_percent, student_deposits_percent, student_engagement_percent]   
        
          sql2 = %Q(
             select * from
             (   SELECT d.name as district_name,
                d.guid as district_guid,
              s.name as school_name,
              p.first_name,
              p.last_name,
                (SELECT count(DISTINCT i.id)
                  FROM interactions i
                  WHERE
                    (i.page = '/teachers/home' or i.page = '/mobile/v1/teachers/auth')
                    AND i.person_id = p.id
                    AND i.created_at >= '#{@beginning_day}'
                    AND i.created_at <=  '#{@ending_day}'
                    ) as login_count,
                 (SELECT count(DISTINCT tcoc.id)
                 FROM otu_codes tcoc, plutus_transactions tcpt
                 WHERE tcoc.person_school_link_id = psl.id 
                 AND tcpt.commercial_document_id  = tcoc.id 
               AND tcpt.commercial_document_type = 'OtuCode' 
               AND tcpt.description ilike '%ebucks for student%'
                    AND tcoc.created_at >= '#{@beginning_day}'
                   AND tcoc.created_at <=  '#{@ending_day}'
                   ) as credits_count
                FROM districts d, schools s, person_school_links psl, people p
                where d.guid = s.district_guid and s.id = psl.school_id and p.id = psl.person_id and p.type in ('Teacher','SchoolAdmin')
                AND p.status = 'active' AND psl.status = 'active'
                   #{@districts_where} 
                 ) as teacher_ranking
             order by (credits_count + login_count) desc
             limit 10
          )
          top_ten_teachers = Teacher.find_by_sql(sql2)
          csv << [""]          
          csv << [""]
          csv << ["Top 10 teachers for district #{row.guid}"]
          csv << [""]
          csv << ["School Name","First Name","Last Name","Count Times Logged In","Count Times Issued Credits"]  
          top_ten_teachers.each do | row2 |
              csv << [row2.school_name, row2.first_name, row2.last_name, row2.login_count, row2.credits_count ]
          end     
          
          sql3 = %Q(
              SELECT 
                     p.grade,
                     COUNT (i.id) AS login_count,
                     extract(dow from  i.created_at) AS day_index,
                     to_char(i.created_at, 'day') AS day_name
                FROM districts d,
                     schools s,
                     people p,
                     person_school_links psl,
                     interactions i
               WHERE     s.id = psl.school_id
                     AND p.id = psl.person_id
                     AND p.status = 'active'
                     AND psl.status = 'active'
                     AND p.type IN ('Student')
                     AND s.district_guid = d.guid
                     AND i.person_id = psl.person_id
                     AND (i.page = '/students/home' or i.page = '/mobile/v1/students/auth')
                     #{@districts_where}
                     AND i.created_at >= '#{@beginning_day}'
                     AND i.created_at <=  '#{@ending_day}'
            GROUP BY 
                     extract(dow from  i.created_at),
                     to_char(i.created_at, 'day'),     
                     grade
            ORDER BY extract(dow from  i.created_at)          
          )
          student_logins =  Student.find_by_sql(sql3)
          csv << [""]          
          csv << [""]
          csv << ["Student login count by grade and weekday for district #{row.guid}"]
          csv << [""]
          csv << ["Grade","Day","Login Count"]  
          student_logins.each do | row3 |
              csv << [row3.grade, row3.day_name, row3.login_count ]
          end  
          csv << [""]          
          csv << ["-----------------------------------------------------------------------"]             
          csv << [""]   
          csv << [""]   
        end 
      end
    end
  end
end
