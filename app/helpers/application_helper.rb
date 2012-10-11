module ApplicationHelper
  # In the context of views, the current_person gets decoratred
  # NOTE: I'm not sure if this is confusing, since current_person will be different depending on the context (controller or view)
  # For now I think it makes sense, but we can rethink if it confuses anyone...
  def current_person
    if current_user && current_user.person
      PersonDecorator.decorate(current_user.person)
    end
  end
  
  def active_if(visitor_type)
    # We don't set visitor_type for students, but we want the helper to be sensible
    visitor_type = '' if visitor_type == 'student'
    if params[:visitor_type].to_s == visitor_type
      'active'
    end
  end

  def current_school
    School.find(session[:current_school_id])
  end

  def current_school_name
    school = nil
    if session && session[:current_school_id] && current_user
      school = School.find(session[:current_school_id])
    end
    if school.nil? && current_user
      school = current_user.person.schools.first
    end
    if school.nil? && request.subdomain
      school = School.find_by_store_subdomain(request.subdomain)
    end
    school.nil? ? "Unknown School" : school.name
  end


  def buck_link(buck)
    link_to 'Redeem Buck', "/bank/redeem_bucks", buck
  end

  def filter_widget
    render "shared/filter/filter_widget"
  end

  def image_processor
    ::Dragonfly[:images]
  end

  def store_type
    if request && request.subdomain == 'le'
      'lestore'
    else
      'schoolstore'
    end
  end


  def render_reward_highlights products
    render 'shared/rewards_highlights', products: products
  end

  def avatar_for(person, geometry='50x50#')
    avatar_img = if person.avatar.present?
                   person.avatar.image
                 else
                   default_avatar_path = Rails.root.join('app/assets/images/default_avatar.png').to_s
                   image_processor.fetch_file(default_avatar_path)
                 end
    image_tag(avatar_img.thumb(geometry).url)
  end
end
