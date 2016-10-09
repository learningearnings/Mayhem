module Reports
  class NewStudentLoginsReport
    
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
                 s.name AS school_name,
                 p.id AS le_person_id,
                 p.sti_id AS sti_user_id,
                 p.last_name AS student_last_name,
                 p.first_name AS student_first_name,
                 p.grade,
                 COUNT (i.id) AS login_count,
                 DATE (i.created_at) AS date
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
        GROUP BY le_person_id,
                 DATE (i.created_at),
                 le_school_id,
                 sti_user_id,
                 sti_school_id,
                 sti_district_guid,
                 district_name,
                 psl.status,
                 psl.id,
                 grade
        ORDER BY school_name,
                 student_first_name,
                 student_last_name,
                 date
      )
      @rows = Person.find_by_sql(sql)
      
    end
    
    def run
      csv = CSV.generate do |csv|
        csv << ["Student logins report spaning #{@total_days} days for districts #{@districts}"]
        csv << [""]
        csv << ["district_name","sti_district_guid","sti_school_id","le_school_id","school_name","le_person_id","sti_user_id","student_last_name","student_first_name","grade","login_count","date"]
        @rows.each do | row |
          csv << [row.district_name, row.sti_district_guid,row.sti_school_id,row.le_school_id,row.school_name, row.le_person_id,row.sti_user_id,row.student_last_name,row.student_first_name,row.grade,row.login_count,row.date]
        end
      end
    end
  end
end
