class Mobile::V1::Teachers::PurchasesController < Mobile::V1::Teachers::BaseController
  def index
    @school = current_school
    reward_deliveries.each do |reward_delivery|
       if reward_delivery.reward && reward_delivery.reward.product # Guard against deleted rewards
        @data << generate_row(reward_delivery)
      end
    end  
    render json: @data.to_json 
  end
  
  def generate_row(reward_delivery)
    person = reward_delivery.to
    deliverer = reward_delivery.reward.product.person ? reward_delivery.reward.product.person : reward_delivery.from
    homeroom = person.homeroom
    if homeroom
      teacher = homeroom.teachers.first
      if teacher
        cr_name = "#{teacher.try(:last_name)}: #{homeroom.name}"
      else
        cr_name = homeroom.name
      end
    else
      cr_name = "None"  
    end   
    row = Hash.new
    row['delivery_teacher'] = name_with_options(deliverer, parameters.teachers_name_option)
    row['student'] = [name_with_options(person, parameters.students_name_option), "(#{person.user.username})"].join(" ")
    row['classroom'] = cr_name
    row['grade'] = School::GRADE_NAMES[person.try(:grade)]
    row['purchased'] = time_ago_in_words(reward_delivery.created_at) + " ago"
    row['reward'] = reward_delivery.reward.product.name
    row['quantity'] = reward_delivery.reward.quantity
    row['status'] = reward_delivery.status.humanize
    row['reward_delivery_id'] = reward_delivery.id
    row['delivery_status'] = reward_delivery.status
    row
  end

  def name_with_options(person, option = "Last, First")
    name_array = [person.try(:last_name), person.try(:first_name)]
    name_array.reverse! if option == "First, Last"
    option == "Last, First" || option == "" ? name_array.join(", ") : name_array.join(" ")
  end  
  
  def reward_deliveries
    base_scope = reward_delivery_base_scope
    #potential_filters.each do |filter|
    #  filter_option = send(filter)
    #  base_scope = base_scope.send(*filter_option) if filter_option
    #end
    base_scope
  end 
  
  def reward_delivery_base_scope
    RewardDelivery.includes(to: [ :person_school_links ], reward: [:product]).where(to: { person_school_links: { school_id: @school.id, status: 'active' } })
  end  
   
  def potential_filters
    [:date_filter, :reward_status_filter, :teachers_filter, :reward_creator_filter, :sort_by]
  end
    
  def deliver
    render json: { status: :ok }
  end
  
end
