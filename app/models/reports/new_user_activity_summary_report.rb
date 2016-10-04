module Reports
  class NewUserActivitySummaryReport
    
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
        SELECT d.name AS district_name,
        s.district_guid AS sti_district_guid,
        s.sti_id AS sti_school_id,
        s.id AS le_school_id,
        s.name AS school_name
        FROM districts d, schools s
        WHERE s.district_guid = d.guid 
          AND s.status = 'active'
          #{@districts_where}          
        ORDER BY district_name, school_name
      )
      @schools = School.find_by_sql(sql)
      
    end
    
    def run
      csv = CSV.generate do |csv|
        csv << ["User activity summary report spaning #{@total_days} days for districts #{@districts}"]
        csv << [""]
        csv << ["District Name","STI District_GUID","STI School ID","LE School Id","School Name","Teacher Count","Teacher Login Count","Teachers Issuing Credits Count","Student Count","Student Login Count","Students Purchasing Rewards Count","Students Receiving Credits Count","Students Depositing Credits Count"]
        @schools.each do | s |
          
          sql2 = %Q(
            SELECT s.name,
            (SELECT count(tp.id)
              FROM people tp, person_school_links tpsl
              WHERE tpsl.school_id = s.id
                AND tp.type IN ('Teacher','SchoolAdmin')
                AND tpsl.person_id = tp.id
             AND tpsl.status = 'active'
             AND tp.status = 'active') AS teacher_count,
            (SELECT count(DISTINCT p.id)
              FROM people p, person_school_links psl, spree_users su
              WHERE s.id = psl.school_id AND p.id = psl.person_id
              AND p.type IN ('Teacher','SchoolAdmin')
              AND p.status = 'active' AND psl.status = 'active'
              AND su.person_id = p.id
              AND su.last_sign_in_at >= '#{beginning_day}' AND su.last_sign_in_at <= '#{ending_day}' ) AS teacher_login_count,
            (SELECT count(DISTINCT tcp.id)
             FROM people tcp, person_school_links tcpsl, otu_codes tcoc, plutus_transactions tcpt
             WHERE s.id = tcpsl.school_id AND tcp.id = tcpsl.person_id
             AND tcoc.person_school_link_id = tcpsl.id 
             AND tcpt.commercial_document_id  = tcoc.id 
           AND tcpt.commercial_document_type = 'OtuCode' 
           AND tcpt.description ilike '%ebucks for student%'
               AND tcp.type IN ('Teacher','SchoolAdmin')
               AND tcp.status = 'active' AND tcpsl.status = 'active'
               AND tcoc.created_at >= '#{beginning_day}' AND tcoc.created_at <=  '#{@ending_day}' ) AS teachers_issuing_credits_count,
            (SELECT count(sp.id)
              FROM people sp, person_school_links spsl
              WHERE spsl.school_id = s.id
                AND sp.type IN ('Student')
                AND spsl.person_id = sp.id
             AND spsl.status = 'active'
             AND sp.status = 'active') AS student_count,
            (SELECT count(DISTINCT p.id)
              FROM people p, person_school_links psl, spree_users su
              WHERE s.id = psl.school_id AND p.id = psl.person_id
              AND p.type IN ('Student')
              AND p.status = 'active' AND psl.status = 'active'
              AND su.person_id = p.id
              AND su.last_sign_in_at >= '#{beginning_day}' AND su.last_sign_in_at <= '#{ending_day}') AS student_login_count,
            (SELECT count(DISTINCT sp.id)
              FROM people sp, person_school_links sppsl, plutus_transactions sppt, plutus_amounts sppa, person_account_links sppal
              WHERE sppsl.school_id = s.id AND sppsl.person_id = sp.id AND sp.status = 'active' AND sppsl.status = 'active'
               AND sp.type = 'Student'
               AND sppa.transaction_id = sppt.id
               AND sppa.account_id = sppal.plutus_account_id AND sppal.person_school_link_id = sppsl.id
               AND sppt.description = 'Reward Purchase'
               AND sppt.created_at >= '#{beginning_day}' AND sppt.created_at <=  '#{@ending_day}'
              ) AS students_purchasing_rewards_count,
            (SELECT count(DISTINCT sr.id)
              FROM people sr, person_school_links srpsl, plutus_transactions srpt, plutus_amounts srpa, person_account_links srpal
              WHERE srpsl.school_id = s.id AND srpsl.person_id = sr.id AND sr.status = 'active' AND srpsl.status = 'active'
               AND sr.type = 'Student'
               AND srpa.transaction_id = srpt.id
               AND srpa.account_id = srpal.plutus_account_id AND srpal.person_school_link_id = srpsl.id
               AND (srpt.description IN ('Issue Printed Credits to Student','Issue Credits to Student') OR srpt.description ILIKE 'Weekly Credits for%' OR srpt.description ILIKE 'Monthly Credits for%' )
               AND srpt.created_at >= '#{beginning_day}'  AND srpt.created_at <=  '#{@ending_day}'
              ) AS students_receiving_credits_count,
            (SELECT count(DISTINCT sd.id)
              FROM people sd, person_school_links sdpsl, plutus_transactions sdpt, plutus_amounts sdpa, person_account_links sdpal
              WHERE sdpsl.school_id = s.id AND sdpsl.person_id = sd.id AND sd.status = 'active' AND sdpsl.status = 'active'
               AND sdpa.transaction_id = sdpt.id
               AND sd.type = 'Student'
               AND sdpa.account_id = sdpal.plutus_account_id AND sdpal.person_school_link_id = sdpsl.id
               AND (sdpt.description IN ('Issue Printed Credits to Student','Issue Credits to Student') OR sdpt.description ILIKE 'Credits Earned for %')
               AND sdpt.created_at >= '#{beginning_day}' AND sdpt.created_at <=  '#{@ending_day}' 
              ) AS students_depositing_credits_count
            FROM schools s          
          )
          sql2 = sql2 + " where s.id = #{s.le_school_id} "
          p = Person.find_by_sql(sql2).first          
          csv << ["#{s.district_name}","#{s.sti_district_guid}","#{s.sti_school_id}","#{s.le_school_id}","#{s.school_name}","#{p.teacher_count}","#{p.teacher_login_count}","#{p.teachers_issuing_credits_count}","#{p.student_count}","#{p.student_login_count}","#{p.students_purchasing_rewards_count}","#{p.students_receiving_credits_count}","#{p.students_depositing_credits_count}"]        end
      end
    end
  end
end
