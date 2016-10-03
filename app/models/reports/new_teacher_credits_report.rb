module Reports
  class NewTeacherCreditsReport
    
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
        select d.name as district_name,
        s.district_guid as sti_district_guid,
        s.sti_id as sti_school_id,
        s.id as le_school_id,
        s.name as school_name,
        p.id as le_person_id,
        p.sti_id as sti_user_id,
        p.last_name as teacher_last_name,
        p.first_name as teacher_first_name,
        SUM(oc.points) as total_credits,
        COUNT(oc.id) as num_of_credits,
        COUNT(DISTINCT oc.student_id) as num_of_students,
        psl.status as status,
        DATE(oc.created_at) as date,
        occ.name as credit_description,
        (case 
          when (select count(*) from person_school_classroom_links pscl where pscl.person_school_link_id = psl.id) > 0 
          then 'Y' 
          else 'N' 
          end ) as has_classroom
        from districts d, schools s, people p, person_school_links psl, otu_codes oc 
        LEFT JOIN otu_code_categories occ ON oc.otu_code_category_id = occ.id, plutus_transactions pt
        where s.id = psl.school_id and p.id = psl.person_id and oc.person_school_link_id = psl.id 
        and pt.commercial_document_id  = oc.id 
        and pt.commercial_document_type = 'OtuCode' 
        and p.type in ('Teacher','SchoolAdmin') and s.district_guid = d.guid 
        and p.status = 'active' and psl.status = 'active'
        #{@districts_where}
        AND oc.created_at >= '#{@beginning_day}'
        AND oc.created_at <=  '#{@ending_day}'
        GROUP BY le_person_id,DATE(oc.created_at),credit_description, le_school_id, sti_user_id, sti_school_id, sti_district_guid, district_name, psl.status, psl.id
        ORDER BY school_name, teacher_first_name, teacher_last_name, date
      )
      @rows = Person.find_by_sql(sql)
      
    end
    
    def run
      csv = CSV.generate do |csv|
        csv << ["Teacher credits report spaning #{@total_days} days for districts #{@districts}"]
        csv << [""]
        csv << ["district_name","sti_district_guid","sti_school_id le_school_id","school_name le_person_id","sti_user_id","teacher_last_name","teacher_first_name","total_credits","num_of_credits","num_of_students","status","date","credit_description","has_classroom"]
        @rows.each do | row |
          csv << [row.district_name, row.sti_district_guid, row.sti_school_id, row.school_name, row.le_person_id, row.sti_user_id, row.teacher_last_name,row.teacher_first_name,row.total_credits,row.num_of_credits,row.num_of_students,row.status,row.date,row.credit_description,row.has_classroom]
        end
      end
    end
  end
end
