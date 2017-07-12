module Reports
  class NewStudentPurchasesReport
    
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
                 p.grade AS student_grade,
                 rd.id as reward_delivery_id      
            FROM districts d,
                 schools s,
                 people p,
                 person_school_links psl,
                 reward_deliveries rd
           WHERE     rd.to = p.id
                 AND p.status = 'active'
                 AND psl.status = 'active'
                 AND s.id = psl.school_id
                 AND p.id = psl.person_id
                 AND p.type IN ('Student')
                 AND s.district_guid = d.guid
                 #{@districts_where}
                 AND rd.created_at >= '#{@beginning_day}'
                 AND rd.created_at <=  '#{@ending_day}'
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
        csv << ["Student purchases report spaning #{@total_days} days for districts #{@districts}"]
        csv << [""]
        csv << ["district_name","sti_district_guid","sti_school_id","le_school_id","school_name","le_person_id","sti_user_id","student_last_name","student_first_name","student_grade","reward creator","delivered by","purchased","reward","price","quantity","status"]
        
        @rows.each do | row |
          reward_delivery = RewardDelivery.find(row.reward_delivery_id)
          reward_creator = reward_delivery.reward.product.person ? reward_delivery.reward.product.person.name : reward_delivery.from.name
          delivered_by = reward_delivery.delivered_by.present? ? reward_delivery.delivered_by.name : reward_delivery.from.name

          csv << [row.district_name, row.sti_district_guid, row.sti_school_id, row.le_school_id, row.school_name, row.le_person_id, row.sti_user_id, row.student_last_name,row.student_first_name,row.student_grade,
            reward_creator, delivered_by, reward_delivery.created_at, reward_delivery.reward.product.name, reward_deliver.reward.price, reward_delivery.reward.quantity, reward_delivery.status.humanize]
        end
      end
    end
  end
end
