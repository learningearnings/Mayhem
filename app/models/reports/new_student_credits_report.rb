module Reports
  class NewStudentCreditsReport
    
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
      end
      @total_days = (@ending_day.to_date - @beginning_day.to_date).to_i
      
      sql = %Q(     
          SELECT d.name AS district_name,
                 s.district_guid AS sti_district_guid,
                 s.sti_id AS sti_school_id,
                 s.id AS le_school_id,
                 s.name AS school_name,
                 p.id AS le_person_id,
                 p.sti_id AS sti_user_id,
                 p.last_name AS student_last_name,
                 p.first_name AS student_first_name,
                 p.grade AS student_grade,
                 DATE (pt.created_at) AS date,
                 psl.status AS status,
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
                    AS credits_awarded_by_system
            FROM districts d,
                 schools s,
                 people p,
                 person_school_links psl,
                 plutus_transactions pt,
                 plutus_amounts pa,
                 person_account_links pal
           WHERE     pa.transaction_id = pt.id
                 AND pa.account_id = pal.plutus_account_id
                 AND pal.person_school_link_id = psl.id
                 AND p.status = 'active'
                 AND psl.status = 'active'
                 AND s.id = psl.school_id
                 AND p.id = psl.person_id
                 AND p.type IN ('Student')
                 AND s.district_guid = d.guid
                 #{@districts_where}
                 AND pt.created_at >= '#{@beginning_day}'
                 AND pt.created_at <=  '#{@ending_day}'
        GROUP BY le_person_id,
                 DATE (pt.created_at),
                 student_grade,
                 le_school_id,
                 sti_user_id,
                 sti_school_id,
                 sti_district_guid,
                 district_name,
                 psl.status,
                 psl.id
        ORDER BY district_name,
                 school_name,
                 student_first_name,
                 student_last_name,
                 date
      )
      @rows = Person.find_by_sql(sql)
      
    end
    
    def run
      csv = CSV.generate do |csv|
        csv << ["Student credits report spaning #{@total_days} days for districts #{@districts}"]
        csv << [""]
        csv << ["district_name","sti_district_guid","sti_school_id","le_school_id","school_name","le_person_id","sti_user_id","student_last_name","student_first_name","student_grade","date","status","total_credits_deposited","total_credits_spent_on_purchase","total_credits_refunded","credits_awarded_by_teacher","credits_awarded_by_system"]
        @rows.each do | row |
          csv << [row.district_name, row.sti_district_guid, row.sti_school_id, row.school_name, row.le_person_id, row.sti_user_id, row.student_last_name,row.student_first_name,row.student_grade,row.date,row.status,row.total_credits_deposited,row.total_credits_spent_on_purchase,row.total_credits_refunded,row.credits_awarded_by_teacher,row.credits_awarded_by_system]
        end
      end
    end
  end
end
