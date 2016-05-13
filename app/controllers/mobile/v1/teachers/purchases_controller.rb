class Mobile::V1::Teachers::PurchasesController < Mobile::V1::Teachers::BaseController
  def index
    
    #filter by Teacher, default current person
    
    #filter by Student, default all students for school
    
    #filter by date, default last 30days
    
    #order by reward delivery create date desc
    @school = current_school
    @teacher = current_person
    
    @purchases = reward_deliveries
  end
  
  def reward_creator_options
    @people = current_school.teachers
  end
  
  def student_options
    @people = current_school.students
  end
  
  def reward_deliveries
      base_scope = reward_delivery_base_scope
      potential_filters.each do |filter|
        filter_option = send(filter)
        base_scope = base_scope.send(*filter_option) if filter_option
      end
      #base_scope = base_scope.page(@current_page).per(200)
      base_scope
  end
  
  def potential_filters
    [:reward_creator_filter, :student_filter, :date_from_filter, :date_to_filter]
  end  
  
  def reward_creator_filter
    if params[:reward_creator_filter].blank?
      if @teacher
        rewards = @teacher.products.collect { | r | r.id }
        [:where, { reward: {product: { id: rewards} } }]
      else
        [:scoped]
      end        
    else
      if params[:reward_creator_filter] == "ALL"
        [:scoped]
      else
        #get all rewards created by the selected rewards creator
        teacher = Teacher.find(params[:reward_creator_filter])
        rewards = teacher.products.collect { | r | r.id }
        [:where, { reward: {product: { id: rewards} } }]
      end
    end
  end
  
  def date_from_filter
    if params[:date_from_filter].blank?
      date_from_str = " reward_deliveries.created_at >= '#{(Time.now - 1.month).to_date}' " 
      [:where, date_from_str ]      
    else
      date_from_str = " reward_deliveries.created_at >= '#{params[:date_from_filter]}' " 
      [:where, date_from_str ]
    end
  end
  
  def date_to_filter
    if params[:date_to_filter].blank?
      [:scoped]      
    else
      date_to_str = " reward_deliveries.created_at < ('#{params[:date_to_filter]}'::date + '1 day'::interval) " 
      [:where, date_to_str ]      
    end    
  end
  
  def student_filter
    if params[:student_filter].blank?
      [:scoped]      
    else
      #get all rewards delivered to the student
      [:where, { to_id: params[:student_filter] }]
    end
  end
  
  def reward_delivery_base_scope
    RewardDelivery.includes(to: [ :person_school_links ], reward: [:product]).where(to: { person_school_links: { school_id: @school.id, status: 'active' } })
  end  
end
